class Podcast < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search,
    :against => [:title, :description],
    :using => {
      :tsearch => {:prefix => true}
    }
  mount_uploader :image, ImageUploader
  has_many :sources
  has_many :owners, through: :sources, counter_cache: :subscriber_count
  after_save :set_subscriber_count!

  acts_as_taggable_on :categories

  scope :listened, -> {
    where('(select podcast_id from sources inner join opml_files_sources on opml_files_sources.source_id = sources.id inner join opml_files on opml_files.id = opml_file_id where podcast_id = podcasts.id and opml_files.type != ? limit 1) is not null', 'IgnoreFile')
  }
  scope :recent_updates, -> {
    joins(:sources => :episodes).
     order('max(episodes.pubdate) desc').
     group('podcasts.id').
     select('podcasts.*, (array_agg(episodes.id))[0] as episode_id').
     where('pubdate > ?',1.month.ago)
  }


  def update_meta_information(parsed_feed)
    self.title ||= parsed_feed.title if parsed_feed.title
    self.description ||= take_first(parsed_feed, [:itunes_summary, :description, :title]).strip rescue nil
    self.language = [ parsed_feed.entries.map(&:summary), self.description].join('. ').language
    #itunes_categories
    image = take_first(parsed_feed, [:itunes_image, :image])
    unless image?
      begin
        self.remote_image_url = image if image
      rescue ArgumentError
      end
    end
    if !self.save
      self.image = nil
      self.remote_image_url = nil
      self.image.remove!
      self.valid? # hack -> validation hooks loeschen image
      self.image.remove!
      self.save!
    end
  end

  def to_param
    if title?
      "#{id}-#{title.to_url}"
    else
      id.to_s
    end
  end

  def set_subscriber_count!
    update_column :subscriber_count, owners.count('distinct owners.id')
  end
  private
  def take_first(object, methods)
    methods.select{|m| object.respond_to?(m)}.
      map{|m| object.send(m) }.
      find{|i|i}
  end

end
