class Source < ActiveRecord::Base
  has_and_belongs_to_many :opml_files


  def fetch_meta_information
    self.title ||= parsed_feed.title
    self.description ||= parsed_feed.itunes_summary.strip
    # self.language ||= feed.language
    #itunes_categories
    binding.pry
    # feed.itunes_image

    self.save!
  end

  def parsed_feed
    @parse_feed ||=  Feedzirra::Feed.fetch_and_parse(url)
  end


end
