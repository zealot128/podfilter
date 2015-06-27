Fabricator :owner  do
end

Fabricator :admin, from: :owner do
  admin true
end

Fabricator :source  do
  url { sequence(:url) {|i| "http://www.example.com/podcast#{i}.xml" } }
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
  name 'Standard-File'
  type 'OpmlFile'
  source <<-DOC
<?xml version='1.0' encoding='utf-8' standalone='no' ?><opml version="1.1"></opml>
  DOC
end
