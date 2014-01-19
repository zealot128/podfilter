require "spec_helper"
describe OpmlImport, sidekiq: :fake do
  let(:owner) { Fabricate(:owner) }
  let(:service) { OpmlImport.new(opml, owner) }

  context 'import' do
    let(:opml)  { File.open('spec/fixtures/hacker.opml') }
    it 'initializes' do
      expect(service.owner).to eq(owner)
      expect(service.text).to include '<?xml'
    end

    it 'creates opml_file object' do
      service.run!
      expect(OpmlFile.count).to eq(2)
      OpmlFile.no_ignore.first.tap do |file|
        expect(file.owner).to eq(owner)
        expect(file.source).to include '<?xml'
        expect(file.name).to match(/Import vom \d{2}\.\d{2}\.\d{4}/)
      end
    end

    specify 'parses the file and creates the sources' do
      service.run!
      expect(Source.count).to eq(14)
      Source.first.tap do |source|
        expect(source.url).to   eq('http://feeds.feedburner.com/RaumzeitlaborPodcast')
        expect(source.opml_files).to eq([OpmlFile.no_ignore.first])
      end

      expect {
        service.run!
      }.to_not change(Source, :count)
      expect(OpmlFile.no_ignore.first.sources.count).to eq(14)


      expect(SourceUpdateWorker.jobs.count).to eq(14)
    end
  end

  context 'beyondPod' do
    let(:opml) { File.open('spec/fixtures/my.opml') }
    specify 'beyondPod opml' do
      service.run!
      expect(Source.count).to be > 29
      expect(service.log).to be_kind_of Array
    end
  end

  context 'invalid text' do
    let(:opml) { '1029ashfa' }
    specify  do
      service.run!
      expect(service.log).to be_present
    end
  end

  context 'invalid xml' do
    let(:opml) { File.open('spec/fixtures/hacker-latin1.opml')}
    specify  do
      service.run!
      expect(service.log.to_s).to include 'File Encodings kaputt'
      expect(Source.count).to eq(14)
    end
  end

  specify 'sendet bloedsinn, beispiel: Bild'

end
