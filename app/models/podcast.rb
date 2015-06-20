class Podcast < ActiveRecord::Base
  has_and_belongs_to_many :categories
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

  scope :uncategorized, -> { where('(select category_id from categories_podcasts where podcast_id=podcasts.id limit 1) is null') }
  scope :active, -> { where('(select active from sources where sources.podcast_id = podcasts.id and active = \'t\' limit 1) is not null') }

  acts_as_taggable_on :itunes_categories

  scope :listened, -> {
    where('subscriber_count > 2')
  }
  scope :recent_updates, -> {
    joins(:sources => :episodes).
     order('max(episodes.pubdate) desc').
     group('podcasts.id').
     select('podcasts.*, (array_agg(episodes.id))[0] as episode_id').
     where('pubdate > ?',1.month.ago)
  }

  def similar_podcasts(limit: 10)
    ids = SimilarPodcasts.new.similar(self, limit: limit)
    Podcast.where(id: ids).sort_by{|i| ids.index(i.id)}
  end

  def merge(*others)
    others = others.flatten.reject{|i| i.id == id }
    Podcast.transaction do
      Source.where(podcast_id: others).update_all podcast_id: id
      Podcast.where(id: others).destroy_all
      save
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

  def podlove_data
    {
      title: title,
      subtitle: "",
      description: description,
      cover: 'http://www.podfilter.de' + image.url(:medium),
      feeds: sources.popular.map do |s|
        {
          type: 'audio',
          format: s.short_format,
          url: s.url
        }
      end
    }
  end
end
