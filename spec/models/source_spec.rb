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



end
