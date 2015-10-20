class FeedFetcher
  attr_reader :source
  def initialize(source)
    @source = source
  end

  def run!
    if parsed_feed.is_a?(Fixnum) or (parsed_feed.title.blank? and parsed_feed.entries.count == 0)
      source.update_column :offline, true
    else
      source.update_column :offline, false
      full_refresh
      source.save!
    end
  end

  private

  def parsed_feed
    @parse_feed ||= Feedjira::Feed.fetch_and_parse(source.url)
                                                   # max_redirects: 5,
                                                   # timeout: 30)
  rescue Feedjira::FetchFailure, Feedjira::NoParserAvailable, Faraday::ClientError
    404
  end

  def update_entries
    parsed_feed.entries.each do |entry|
      guid = entry.respond_to?(:entry_id) ? entry.entry_id : entry.guid
      if guid.blank?
        guid = entry.published && entry.published.to_s
      end
      next if guid.blank?

      episode = source.episodes.where(guid: guid.slice(0,255)).first_or_initialize
      episode.title = entry.title.try(:slice, 0, 255)
      episode.url   = entry.url.try(:slice, 0, 255)
      episode.description = entry.summary
      episode.pubdate = entry.published
      episode.media_url = entry.enclosure_url
      episode.save
    end
  end

  def full_refresh
    fetch_meta_information
    update_podcast_meta_information(source.podcast)
    check_redirect
    if !source.redirected_to_id
      update_entries
    end
  end

  def check_redirect
    if source.url != parsed_feed.feed_url
      parent = Source.where(url: parsed_feed.feed_url).first_or_initialize
      parent.podcast ||= source.podcast
      parent.save
      source.opml_files.each do |oml|
        parent.opml_files << oml unless parent.opml_files.include?(oml)
      end
      source.opml_files = []
      source.redirected_to = parent
    else
      source.update_column :redirected_to_id, nil
    end
  end

  def fetch_meta_information
    source.podcast ||= Podcast.where(title: parsed_feed.title).first_or_initialize
    source.format = parsed_feed.try(:entries).try(:first).try(:enclosure_type) || 'audio/mp3'
  end

  # TODO falls es der "Main" Feed ist, dann auch update erlauben
  def update_podcast_meta_information(podcast)
    podcast.title ||= parsed_feed.title if parsed_feed.title
    podcast.description ||= take_first(parsed_feed, [:itunes_summary, :description, :title]).strip rescue nil
    text = ActionController::Base.new.view_context.strip_tags [ parsed_feed.entries.map(&:summary), podcast.description, podcast.title].join('. ')
    podcast.language = text.language

    ItunesCategories.categories_match(podcast, parsed_feed)

    image = take_first(parsed_feed, [:itunes_image, :image])
    unless podcast.image?
      begin
        podcast.image.ignore_download_errors = true
        podcast.remote_image_url = image if image
      rescue ArgumentError
      end
    end
    if !podcast.save
      podcast.image = nil
      podcast.remote_image_url = nil
      podcast.send(:_mounter, :image).instance_variable_set('@remote_url', nil)
      podcast.send(:_mounter, :image).instance_variable_set('@download_error', nil)
      podcast.save!
    end
  end

  def take_first(object, methods)
    methods.select{|m| object.respond_to?(m)}.
      map{|m| object.send(m) }.
      find{|i|i}
  end
end
