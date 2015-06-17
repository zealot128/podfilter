class AutoImport
  def initialize
  end

  def self.run_all
    AutoImport::BitloveImportPodcasts.run
  end

  def conflict!(source1, source2)
    Rails.logger.error "#{source1.id} and #{source2.id} differ in parent Podcast"
  end

  class BitloveOriginalSourceFetcher < AutoImport
    def run
      sources.each do |source|
        puts source.url
        doc = nil
        begin
          doc = Nokogiri::XML.parse(open(source.url))
        rescue OpenURI::HTTPError => e
          if e.to_s['404']
          else
            Rails.logger.error "Bitlove 500 error #{source.url}"
          end
          next
        end
        other_sources = doc.xpath('//channel/atom:link', atom: 'http://www.w3.org/2005/Atom').select{|i| i['rel'] == 'self' }.map{|i| i['href']}
        other_sources.each do |url|
          existing = Source.where(url: url).first
          if existing
            if existing.podcast_id != source.podcast_id
              conflict!(source, existing)
            else
              next
            end
          else
            source.podcast.sources.create!(url: url, created_at: 1.day.ago)
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
          puts "Processing #{urls.join(', ')}"

          sources = []
          missing = []
          urls.each do |url|
            if source = Source.where(url: url).first
              sources << source
            else
              missing << url
            end
          end
          case sources.count
          when 0
            main = Source.create(url: missing.shift, created_at: 1.month.ago)
            main.full_refresh
          when 1
            main = sources.first
          else
            if sources.map{|i| i.podcast_id }.count == 1
              main = sources.first
            else
              conflict!(sources.first, sources[1])
              next
            end
          end

          s = missing.map do |other_source|
            puts " merging #{other_source} into #{main.url}"
            main.podcast.sources.create!(url: other_source)
          end
          Source.where(id: s.map(&:id)).enqueue
        end
      end
    end
  end
end
