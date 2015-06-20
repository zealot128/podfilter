class AutoImport
  def initialize
  end

  def self.run_all
    AutoImport::BitloveImportPodcasts.run
    AutoImport::BitloveOriginalSourceFetcher.run
    AutoImport::HoersuppeFetcher.run
  end

  def run
    new.run
  end

  def conflict!(source1, source2)
    Rails.logger.error "#{self.class}: #{source1.id} and #{source2.id} differ in parent Podcast"
  end

  def merge!(source1, source2)
    p = [source1.podcast, source2.podcast].sort_by{ |i| -(i.owners_count || 0) }
    p.first.merge(p)
  end

  def append_podcast!(source, url)
    Rails.logger.info "#{self.class}: New Source for #{source.id} -> #{url}"
    if source.podcast.blank?
      main = create_podcast(url)
      main.podcast.sources << source
    else
      source.podcast.sources.create!(url: url, created_at: 1.day.ago).enqueue
    end
  end

  def find_source(url)
    Source.where('url ilike ?', url).first
  end

  def create_podcast(url)
    main = Source.create(url: url, created_at: 1.month.ago)
    main.full_refresh
    main
  end

  def merge_urls_to_podcast(urls)
    sources = []
    missing = []
    main = nil
    urls.each do |url|
      if source = find_source(url)
        sources << source
      else
        missing << url
      end
    end
    case sources.count
    when 0
      Rails.logger.info "#{self.class}: New Source #{missing[0]}"
      main = create_podcast(missing.shift)
    when 1
      main = sources.first
    else
      if sources.map{|i| i.podcast_id }.uniq.count == 1
        main = sources.first
      else
        merge!(sources.first, sources[1])
        return
      end
    end
    if missing.any?
      Rails.logger.info "  merging #{urls.join(', ')}"
    end
    missing.each do |other_source|
      append_podcast!(main, other_source)
    end
  end

  class HoersuppeFetcher < AutoImport
    def initialize(hoersuppe_url)
      @url = hoersuppe_url
    end

    def run
      Rails.logger.info "#{self.class}: Processing #{@url}"
      doc = visit @url
      js = doc.at('.podlove-subscribe-button').parent.search('script').last.text
      urls = js.scan(/"url":"([^"]*)"/).flatten
      merge_urls_to_podcast(urls)
    end

    def self.run
      doc = visit 'http://hoersuppe.de/flattrlist'
      urls = doc.search('.entry-content .FlattrButton').map{|i| i['href']}
      urls.each do |url|
        new(url).run
      end
    end

    def visit(*args)
      self.class.visit(*args)
    end

    def self.visit(url)
      Nokogiri.parse open(url)
    end
  end

  class BitloveOriginalSourceFetcher < AutoImport
    def run
      sources.each do |source|
        doc = nil
        begin
          doc = Nokogiri::XML.parse(open(source.url))
        rescue OpenURI::HTTPError => e
          if !e.to_s['404']
            Rails.logger.error "Bitlove: 500 error #{source.url}"
          end
          next
        end
        other_sources = doc.xpath('//channel/atom:link', atom: 'http://www.w3.org/2005/Atom').select{|i| i['rel'] == 'self' }.map{|i| i['href']}
        other_sources.uniq.each do |url|
          existing = find_source(url)
          if existing
            if existing.podcast_id != source.podcast_id
              conflict!(source, existing)
            else
              next
            end
          else
            append_podcast!(source, url)
          end
        end
      end
    end

    def sources
      Source.where('url like ?', '%bitlove%').where(offline: [nil, false]).
        order('podcast_id, owners_count desc').
        select('distinct on (podcast_id) sources.*')
    end
  end

  class BitloveImportPodcasts < AutoImport
    def run
      doc = Nokogiri::XML.parse(open('http://bitlove.org/directory.opml'))
      users = doc.search('body > outline')

      users.each do |user|
        podcasts = user.search('outline').group_by{|i| i['text']}.values
        podcasts.each do |podcast|
          urls = podcast.map{|i| i['xmlUrl'] }
          Rails.logger.info "Bitlove: processing #{urls.join(', ')}"
          merge_urls_to_podcast(urls)
        end
      end
    end
  end
end
