require "spec_helper"
describe OpmlImport, sidekiq: :fake do
  let(:owner) { Fabricate(:owner) }
  let(:service) { OpmlImport.new(opml, owner) }

  context 'import' do
    let(:opml)  { File.open('spec/fixtures/hacker.opml') }
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


      SourceUpdateWorker.jobs.count.should == 14
    end
  end

  context 'beyondPod' do
    let(:opml) { File.open('spec/fixtures/my.opml') }
    specify 'beyondPod opml' do
      service.run!
      Source.count.should == 30
      service.log.should be_kind_of Array
    end
  end

  context 'invalid text' do
    let(:opml) { '1029ashfa' }
    specify  do
      service.run!
      service.log.should be_present
    end
  end

  context 'invalid xml' do
    let(:opml) { File.open('spec/fixtures/hacker-latin1.opml')}
    specify  do
      service.run!
      service.log.to_s.should include 'File Encodings kaputt'
      Source.count.should == 14
    end
  end

  specify 'sendet bloedsinn, beispiel: Bild'

end
