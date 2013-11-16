require "spec_helper"
describe OpmlImport do
  let(:owner) { Fabricate(:owner) }
  let(:opml)  { File.open('spec/fixtures/hacker.opml') }
  let(:service) { OpmlImport.new(opml, owner) }
  it 'initializes' do
    service.owner.should == owner
    service.text.should include '<?xml'
  end

  it 'creates opml_file object' do
    service.run!
    OpmlFile.count.should == 1
    OpmlFile.first.tap do |file|
      file.owner.should == owner
      file.source.should include '<?xml'
    end
  end

  specify 'parses the file and creates the sources' do
    service.run!
    Source.count.should == 14
    Source.first.tap do |source|
      source.title.should == 'RaumZeitLabor Podcast'
      source.url.should   == 'http://feeds.feedburner.com/RaumzeitlaborPodcast'
      source.opml_files.should == [OpmlFile.first]
    end

    expect {
    service.run!
    }.to_not change(Source, :count)
    OpmlFile.first.sources.count.should == 14
  end

end
