class Source < ActiveRecord::Base
  has_and_belongs_to_many :opml_files
  has_many :episodes
  mount_uploader :image, ImageUploader


  def fetch_meta_information
    self.title ||= parsed_feed.title
    self.description ||= parsed_feed.itunes_summary.strip
    # self.language ||= feed.language
    #itunes_categories
    self.remote_image_url = parsed_feed.itunes_image
    # parsed

    self.save!
  end

  def parsed_feed
    @parse_feed ||=  Feedzirra::Feed.fetch_and_parse(url)
  end

  def update_entries
    parsed_feed.entries.each do |entry|
      episode = episodes.where(guid: entry.guid).first_or_initialize
      episode.title = entry.title
      episode.url   = entry.url
      episode.description = entry.summary
      episode.pubdate = entry.published
      episode.save
    end

  end

end
