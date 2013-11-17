require "spec_helper"
describe Source do
  it 'updates meta information' do
    VCR.use_cassette 'source/c3d2' do
      source = Source.create(url: 'http://www.c3d2.de/podcast.xml')
      source.fetch_meta_information

      source.description.should == 'Pentaradio, Pentacast & Pentamusic vom Chaos Computer Club Dresden.'
      source.title.should == 'C3D2 Podcast'
      source.image.should be_present
    end
  end

  it 'updates feed entries' do
    source = Source.create(url: 'http://www.c3d2.de/podcast.xml')
    VCR.use_cassette 'source/c3d2' do
      source.update_entries
    end

    source.episodes.count.should == 63

    VCR.use_cassette 'source/c3d2' do
      source.update_entries
    end
    source.episodes.count.should == 63
  end

  it 'marks feeds as offline', vcr: true do
    source = Source.create(url: 'https://feeds.feedblitz.com/dasknistern/m4a')
    source.full_refresh
    source.should be_offline
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

  end

  def check_all(url: nil, count: nil, image: true)
    source = Source.create(url: url)
    source.full_refresh
    source.image.should be_present if image
    source.description.should be_present
    source.title.should be_present
    source.episodes.count.should == count if count
  end
end
