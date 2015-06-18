
class DuplicateFinder
  IGNORE = %w[ argovia.ch ]
  def self.cronjob
    new.run
  end

  def self.remove_unwanted
    hosts = %w[
    192.168.179.23:9000
    128.210.157.22:1013
    217.115.153.122
    www.podfilter.de
    ]
    hosts.each do |host|
      Source.where('url like ?', "%#{host}%").each do |s|
        podcast = s.podcast
        s.episodes.delete_all
        s.destroy

        if podcast && podcast.sources.count == 0
          podcast.destroy
        end
      end
    end
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

  def self.by_episode_title(limit: 50)
    all = Episode.joins(:source).group('episodes.title').where('length(title) > 12').having('count(distinct podcast_id) > 1').pluck('title, array_agg(distinct podcast_id)').map{|title, podcast_ids| [title, podcast_ids.sort ]}.select{|t,_| t.present? and t.length > 11 }
    descending = all.group_by{|t,p| p}.map{|p, ps| [p, ps.count]}.select{|p,c| c >= limit }.sort_by{|p,c| -c}
    descending.each do |ids, count, one_title|
      podcast = Podcast.where(id: ids)
      puts "Merging:"
      puts podcast.map{|i|
        titles = i.sources.popular.first.episodes.newest_first.limit(3).map(&:title)
        " * #{i.title.green} http://www.podfilter.de/podcasts/#{i.id} (#{i.sources.map(&:url).join(', ')})"  +
          "  Letzte 3 Titel:\n#{titles.map{|f| "   " + f.blue}. join("\n")}"
      }.join("\n")
      buf = Readline.readline("(j/N) ", true)
      if buf[/j/i]
        p = podcast.sort_by{|i| -i.subscriber_count }
        p.first.merge(p)
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
