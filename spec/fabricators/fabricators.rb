Fabricator :owner  do
end

Fabricator :source  do
  title 'Podcast No.1'
  url 'http://www.example.com/podcast.xml'
  description '...'
  active true
  offline false
end

Fabricator :opml_file do
  owner
  source <<-DOC
<?xml version='1.0' encoding='utf-8' standalone='no' ?><opml version="1.1"></opml>
  DOC
end
