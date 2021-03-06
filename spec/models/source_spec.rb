require "spec_helper"
describe Source do
  def feed(path)
    Source.create(url: "file://#{Rails.root}/spec/fixtures/feeds/#{path}")
  end
  it 'updates meta information', vcr: true do
    source = feed("c3d2.xml")
    source.full_refresh

    expect(source.podcast.description).to eq('Pentaradio, Pentacast & Pentamusic vom Chaos Computer Club Dresden.')
    expect(source.podcast.title).to eq('C3D2 Podcast')
    expect(source.podcast.image).to be_present
  end

  it 'updates feed entries', vcr: true do
    source = feed("c3d2.xml")
    source.full_refresh

    expect(source.episodes.count).to eq(63)
    expect(source.episodes.first.media_url).to be_present

    source.full_refresh
    expect(source.episodes.count).to eq(63)
  end

  it 'marks feeds as offline', vcr: true do
    source = feed('empty.xml')
    source.full_refresh
    expect(source).to be_offline
  end

  describe 'site specific bugs' do
    # Feedburner -> Itunes format nicht richtig erkannt
    it 'updates oreilly kolophon', vcr: true, focus: true do
      check_all url: 'kolophon.xml', count: 10
    end

    it 'updates geek-week', vcr: true do
      check_all url: 'geekweek.xml', image: false
    end

    # Bild ist im falschen Format
    it 'updates slangster', vcr: true do
      check_all url: 'slangster.xml', count: 4
    end

    # image error
    it 'dropnik', vcr: true do
      check_all url: 'dropnik.xml', image: false
    end

    it 'makinet', vcr: true do
      check_all url: 'maikinet.xml', image: false
    end

    it 'schlaflosinmuenchen', vcr: true do
      source = feed('schlaflosinm.xml')
      source.full_refresh
      expect(source.podcast.description).to include 'Dieser Feed wird nicht mehr aktualisiert'
    end

    it 'invalid file', vcr: true do
      source = feed('masskompod.xml')
      source.full_refresh
      expect(source).to be_offline
    end

  end

  describe 'redirect handling' do
    specify 'cre.fm', vcr: true do
      source = Source.create(url: 'http://cre.fm/feed/oga')
      source.opml_files << OpmlFile.create!(name: 'foobar')
      source.full_refresh
      expect(source.redirected_to).should be_present
      expect(source.podcast.sources.count).to be == 2
      expect(source.opml_files.count).to be 0
      expect(source.redirected_to.opml_files.count).to be 1
      expect(source.redirected_to.owners_count).to be 1
      expect(source.format).to be == 'audio/ogg'
    end

  end

  def check_all(url: nil, count: nil, image: true)
    if url['http']
      source = Source.create(url: url)
    else
      source = feed(url)
    end
    source.full_refresh
    expect(source.podcast.image).to be_present if image
    expect(source.podcast.description).to be_present
    expect(source.podcast.title).to be_present
    expect(source.episodes.count).to eq(count) if count
    if count
      expect(source.episodes.count).to eq(count) if count
      expect(Episode.first.media_url).to be_present
    end
  end
end
