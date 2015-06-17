class AutoImport
  def initialize
  end

  def self.run_all
    AutoImport::BitloveImportPodcasts.run
    AutoImport::BitloveOriginalSourceFetcher.run
  end

  def run
    new.run
  end

  def conflict!(source1, source2)
    Rails.logger.error "Bitlove: #{source1.id} and #{source2.id} differ in parent Podcast"
  end

  def append_podcast!(source, url)
    Rails.logger.info "Bitlove: New Source for #{source.id} -> #{url}"
    source.podcast.sources.create!(url: url, created_at: 1.day.ago).enqueue
  end

  def find_source(url)
    Source.where('url ilike ?', url).first
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
          sources = []
          missing = []
          urls.each do |url|
            if source = find_source(url)
              sources << source
            else
              missing << url
            end
          end
          case sources.count
          when 0
            Rails.logger.info "Bitlove: New Source #{url}"
            main = Source.create(url: missing.shift, created_at: 1.month.ago)
            main.full_refresh
          when 1
            main = sources.first
          else
            if sources.map{|i| i.podcast_id }.uniq.count == 1
              main = sources.first
            else
              conflict!(sources.first, sources[1])
              next
            end
          end

          missing.each do |other_source|
            append_podcast(main, other_source)
          end
        end
      end
    end
  end
end
