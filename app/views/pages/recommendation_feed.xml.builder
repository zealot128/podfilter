xml.instruct!
xml.rss(version: "2.0",
        "xmlns:atom"=>"http://www.w3.org/2005/Atom") do

  xml.channel do
    xml.title "Podfilter Empfehlungen für #{@owner.to_s}"
    xml.link recommendation_feed_url(owner_id: @owner)
    xml.description 'Anpassungen nach Einloggen unter http://podfilter.de/ moeglich.'
    xml.lastBuildDate Time.now
    xml.tag!('atom:link', rel: 'self', type: 'application/rss+xml', href: recommendation_feed_url(owner_id: @owner))
    @episodes.each do |episode|
      xml.item do
        xml.title episode.title
        xml.link  episode.url
        xml.pubDate episode.pubdate.rfc822
        xml.description do
          xml.cdata! episode.description
        end
        xml.guid episode.guid
        xml.enclosure(url: episode.media_url, type: episode.media_type)
      end
    end
  end
end
