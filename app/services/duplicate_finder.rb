
class DuplicateFinder
  def self.cronjob
    new.run
  end

  def self.get_dupegroups
    (Rails.cache.read('dupes') || {}).map {|k,v| v + [k] }
  end

  def run
    found_dupes = {}
    Source.find_each do |source|
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
