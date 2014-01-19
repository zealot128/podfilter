class Podcast < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search,
    :against => [:title, :description],
    :using => {
      :tsearch => {:prefix => true}
    }
  mount_uploader :image, ImageUploader
  has_many :sources

  def update_meta_information(parsed_feed)
    self.title ||= parsed_feed.title if parsed_feed.title
    self.description ||= take_first(parsed_feed, [:itunes_summary, :description, :title]).strip rescue nil
    # self.language ||= feed.language
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

  private
  def take_first(object, methods)
    methods.select{|m| object.respond_to?(m)}.
      map{|m| object.send(m) }.
      find{|i|i}
  end
end
