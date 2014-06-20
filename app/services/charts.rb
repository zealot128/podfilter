module Charts
  def self.episode_activity(source)
    baseline = Hash[24.times.map{|i| [I18n.l(i.month.ago, format: '%b %Y'), nil]}.reverse]

    source.episodes.order('pubdate desc').
      where('pubdate > ?', 2.years.ago).
      pluck(:pubdate).
      each{|i|
        key = I18n.l(i, format:'%b %Y')
        baseline[key] ||= 0
        baseline[key] += 1
      }

    {
      values: baseline.values,
      labels: baseline.keys
    }
  end

end
