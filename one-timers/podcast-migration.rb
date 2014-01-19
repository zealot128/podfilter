Source.roots.find_each do |s|
  next unless s.title?
  podcast = Podcast.where(title: s.title).first_or_initialize
  podcast.description ||= s.description
  podcast.image = s.image if s.image? and not podcast.image?
  podcast.save!
  s.podcast = podcast
  s.save! validate: false
  s.all_siblings.each do |ss|
    ss.podcast = podcast
    ss.save! validate: false
  end
end
