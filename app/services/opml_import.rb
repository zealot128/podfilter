class OpmlImport
  attr_reader :owner
  def initialize(file, owner)
    @file = file
    @owner = owner
  end


  def text
    @text ||= case @file
              when String then @file
              when File then @file.read
              end
  end

  def run!
    update_sources(opml)
  end


  protected

  def update_sources(opml_file)
    document = Nokogiri::XML.parse(opml_file.source)
    document.search('outline').each do |outline|
      source = Source.where(url: outline['url']).first_or_create(title: outline['title'])
      if source.opml_files.where('opml_file_id = ?', opml_file.id).count == 0
        source.opml_files << opml_file
      end
      SourceUpdateWorker.perform_async(source.id)
    end
  end

  def opml
    @opml ||= OpmlFile.create(owner: owner, source: text)
  end
end
