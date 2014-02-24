class Category < ActiveRecord::Base
  has_and_belongs_to_many :podcasts

  def self.podcast_counts
    Category.joins(:podcasts).
      group('categories.id').
      select('categories.id,categories.name,count(*) as count')
  end

  def translated_name
    I18n.t("categories.#{name}", default: name)
  end

  def to_param
    "#{id}-#{name.to_url}"
  end
end
