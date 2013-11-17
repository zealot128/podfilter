require "spec_helper"
describe Source do
  it 'updates meta information' do
    VCR.use_cassette 'source/c3d2' do
      source = Source.create(url: 'http://www.c3d2.de/podcast.xml')
      source.fetch_meta_information

      expect(source.description).to eq('Pentaradio, Pentacast & Pentamusic vom Chaos Computer Club Dresden.')
      expect(source.title).to eq('C3D2 Podcast')
      expect(source.image).to be_present
    end
  end

  it 'updates feed entries' do
    source = Source.create(url: 'http://www.c3d2.de/podcast.xml')
    VCR.use_cassette 'source/c3d2' do
      source.update_entries
    end

    expect(source.episodes.count).to eq(63)

    VCR.use_cassette 'source/c3d2' do
      source.update_entries
    end
    expect(source.episodes.count).to eq(63)
  end

  it 'marks feeds as offline', vcr: true do
    source = Source.create(url: 'https://feeds.feedblitz.com/dasknistern/m4a')
    source.full_refresh
    expect(source).to be_offline
  end

  describe 'site specific bugs' do
    # Feedburner -> Itunes format nicht richtig erkannt
    it 'updates oreilly kolophon', vcr: true do
      check_all url: 'http://feeds.feedburner.com/oreillykolophonpodcast', count: 10
    end

    it 'updates geek-week', vcr: true do
      check_all url: 'http://www.geek-week.de/feed/', count: 20, image: false
    end

    # Bild ist im falschen Format
    it 'updates slangster', vcr: true do
      check_all url: 'http://slangster.podspot.de/rss', count: 4
    end

    # image error
    it 'dropnik', vcr: true do
      check_all url: 'http://oliver.drobnik.com/feed/podcast/', image: false
    end

    it 'makinet', vcr: true do
      check_all url: 'http://maikinet-tumblr.podspot.de/rss', image: false, count: 8
    end

    it 'schlaflosinmuenchen', vcr: true do
      source = Source.create(url: 'http://feeds.schlaflosinmuenchen.com/weeklysimAAC.xml')
      source.fetch_meta_information
      expect(source.description).to include 'Dieser Feed wird nicht mehr aktualisiert'
    end

    it 'invalid file', vcr: true do
      source = Source.create(url: 'http://masskompod.rupkalwis.com/podcast.php')
      source.full_refresh
      expect(source).to be_offline
    end

  end

  def check_all(url: nil, count: nil, image: true)
    source = Source.create(url: url)
    source.full_refresh
    expect(source.image).to be_present if image
    expect(source.description).to be_present
    expect(source.title).to be_present
    expect(source.episodes.count).to eq(count) if count
  end
end
