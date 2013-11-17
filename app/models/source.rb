class Source < ActiveRecord::Base
  has_and_belongs_to_many :opml_files
  has_many :owners, through: :opml_files
  has_many :episodes
  mount_uploader :image, ImageUploader

  validates :url, presence: true, uniqueness: true, url: true
  scope :recent, -> {
    joins(:episodes).
    where('episodes.id = (select episodes.id from episodes where episodes.source_id = sources.id and pubdate is not null order by pubdate desc limit 1)').
    select('sources.*, episodes.id as episode_id, episodes.pubdate as pubdate').
    order('episodes.pubdate desc')
  }

  def fetch_meta_information
    self.title = parsed_feed.title
    self.description = take_first(parsed_feed, [:itunes_summary, :description]).strip
    # self.language ||= feed.language
    #itunes_categories
    image = take_first(parsed_feed, [:itunes_image, :image])
    self.remote_image_url = image if image

    self.save!
  end

  def parsed_feed
    Feedzirra::Feed.add_common_feed_element :"itunes:image", :value => :href, :as => :itunes_image
    Feedzirra::Feed.add_common_feed_element :"itunes:summary", :as => :itunes_summary
    Feedzirra::Feed.add_common_feed_element :"itunes:category", :as => :itunes_categories, :value => :text
    Feedzirra::Feed.add_common_feed_element "url", :as => :image

    @parse_feed ||=  Feedzirra::Feed.fetch_and_parse(url)
  end

  def update_entries
    parsed_feed.entries.each do |entry|
      guid = entry.respond_to?(:entry_id) ? entry.entry_id : entry.guid
      episode = episodes.where(guid: guid).first_or_initialize
      episode.title = entry.title
      episode.url   = entry.url
      episode.description = entry.summary
      episode.pubdate = entry.published
      episode.save
    end

  end

  def to_param
    "#{id}-#{title.to_url}"
  end

  private

  def take_first(object, methods)
    methods.select{|m| object.respond_to?(m)}.
      map{|m| object.send(m) }.
      find{|i|i}
  end
end
