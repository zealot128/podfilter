class Episode < ActiveRecord::Base
  belongs_to :source

  scope :newest_first, -> { order('pubdate desc') }
  scope :with_file, -> { where('media_url is not null and media_url != ?', "") }

  def media_type
    case media_url
    when nil then nil
    when /torrent/ then 'application/x-bittorrent'
    when /mp3/ then 'audio/mpeg'
    when /mp4/ then 'video/mp4'
    when /aac/ then 'audio/aac'
    when /ogg/ then 'audio/ogg'
    when /m4a/ then 'audio/mp4'
    else 'audio/mpeg'
    end
  end
end
