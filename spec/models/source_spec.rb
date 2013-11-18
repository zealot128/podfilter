require "spec_helper"
describe Source do
  def feed(path)
    Source.create(url: "file://#{Rails.root}/spec/fixtures/feeds/#{path}")
  end
  it 'updates meta information', vcr: true do
      source = feed("c3d2.xml")
      source.fetch_meta_information

      expect(source.description).to eq('Pentaradio, Pentacast & Pentamusic vom Chaos Computer Club Dresden.')
      expect(source.title).to eq('C3D2 Podcast')
      expect(source.image).to be_present
  end

  it 'updates feed entries', vcr: true do
    source = feed("c3d2.xml")
    source.update_entries

    expect(source.episodes.count).to eq(63)

    source.update_entries
    expect(source.episodes.count).to eq(63)
  end

  it 'marks feeds as offline', vcr: true do
    source = feed('empty.xml')
    source.full_refresh
    expect(source).to be_offline
  end

  describe 'site specific bugs' do
    # Feedburner -> Itunes format nicht richtig erkannt
    it 'updates oreilly kolophon', vcr: true do
      check_all url: 'kolophon.xml', count: 10
    end

    it 'updates geek-week', vcr: true do
      check_all url: 'geekweek.xml', count: 20, image: false
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
      check_all url: 'maikinet.xml', image: false, count: 8
    end

    it 'schlaflosinmuenchen', vcr: true do
      source = feed('schlaflosinm.xml')
      source.fetch_meta_information
      expect(source.description).to include 'Dieser Feed wird nicht mehr aktualisiert'
    end

    it 'invalid file', vcr: true do
      source = feed('masskompod.xml')
      source.full_refresh
      expect(source).to be_offline
    end

  end

  def check_all(url: nil, count: nil, image: true)
    if url['http']
      source = Source.create(url: url)
    else
      source = feed(url)
    end
    source.full_refresh
    expect(source.image).to be_present if image
    expect(source.description).to be_present
    expect(source.title).to be_present
    expect(source.episodes.count).to eq(count) if count
  end
end
