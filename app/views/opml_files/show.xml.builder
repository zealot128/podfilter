xml.instruct!
xml.opml(version: '1.1') do
  xml.head do
    xml.title 'OPML-Export'
    xml.dateCreated Time.now.rfc822
    xml.dateModified @opml_file.updated_at.rfc822
  end
  xml.body do
    @sources.each do |o|
      xml.outline nil, text: o.podcast.title, xmlUrl: o.url, type: 'rss'
    end
  end
end
