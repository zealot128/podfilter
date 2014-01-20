Fabricator :owner  do
end

Fabricator :admin, from: :owner do
  admin true
end

Fabricator :source  do
  title 'Podcast No.1'
  url { sequence(:url) {|i| "http://www.example.com/podcast#{i}.xml" } }
  description '...'
  active true
  offline false
  podcast
end

Fabricator :podcast  do
  title 'Podcast No.1'
  description '...'
end

Fabricator :opml_file do
  owner
  type 'OpmlFile'
  source <<-DOC
<?xml version='1.0' encoding='utf-8' standalone='no' ?><opml version="1.1"></opml>
  DOC
end
