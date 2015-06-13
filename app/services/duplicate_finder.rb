
class DuplicateFinder
  IGNORE = %w[ argovia.ch ]
  def self.cronjob
    new.run
  end

  def self.get_dupegroups
    (Rails.cache.read('dupes') || {}).map {|k,v| v + [k] }
  end

  def self.by_title
    select = "lower(trim(regexp_replace(title, '\\(HD\\)|\\(SD\\)|\\(MP3\\)|\\(MP4\\)|\(\(M4V\)\)', '', 'i')))"
    titles = Podcast.group(select).having('count(*) > 1').count
    titles.keys.each do |title|
      next if title.length < 8
      podcasts = Podcast.where("#{select} = ?", title)
      podcasts.first.merge(podcasts)
    end
  end

  def self.by_url
    select = "regexp_replace(regexp_replace(url, 'https?:', 'http:'), '/$', '')"
    urls = Source.group(select).having('count(*) > 1').count
    urls.keys.each do |url|
      ids = Source.where("#{select} = :url", url: url).pluck(:podcast_id).uniq
      if ids.count > 1
        podcasts = Podcast.where(id: ids).order('subscriber_count desc').to_a
        p = podcasts.shift
        p.merge(podcasts)
      end
    end
  end

  def run
    found_dupes = {}
    ignore = Source.where('url ~ ?', IGNORE.map{|i| Regexp.escape(i) }.join('|')).pluck(:id)
    Source.where('id not in (?)', ignore).find_each do |source|
      dupes =  Source.where('podcast_id != ?', source.podcast_id).where('levenshtein_less_equal(url, ?, 2) <= 2', source.url)
      if dupes.count > 0
        dupes.each do |dupe|
          found_dupes[ [source.id, dupe.id].sort ] = true
        end
      end
    end
    sorted = {}
    found_dupes.keys.sort.each do |k,v|
      sorted[k] ||= []
      sorted[k] << v
    end
    Rails.cache.write('dupes', sorted)
  end
end
