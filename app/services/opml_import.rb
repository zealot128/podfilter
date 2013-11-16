class OpmlImport
  attr_reader :owner, :log
  def initialize(file, owner)
    @file = file
    @owner = owner
    @log = []
  end

  def text
    @text ||= begin
                text = case @file
              when String then @file
              when File then @file.read
              end
                if !text.valid_encoding?
                  @log << "File Encodings kaputt - Nehme LATIN1 an"
                  text = text.force_encoding(Encoding::ISO8859_1).encode(Encoding::UTF_8)
                end
                text
              end
  end

  def run!
    update_sources(opml)
    opml
  end


  protected

  def update_sources(opml_file)
    document = Nokogiri::XML.parse(opml_file.source)
    outlines = document.search('outline')
    if outlines.count ==0
      @log << 'Keine Einträge im OPML-File gefunden!'
      return
    end
    outlines.each_with_index do |outline,i|
      url = outline['url'] || outline['xmlUrl']
      title = outline['title'] || outline['text']
      source = Source.where(url: url).first_or_initialize(title: title)
      was_new_record = source.new_record?
      if source.save
        if source.opml_files.where('opml_file_id = ?', opml_file.id).count == 0
          source.opml_files << opml_file
        end
        if was_new_record
          @log << "#{url} neu hinzugefügt."
          SourceUpdateWorker.perform_async(source.id)
        end
      else
        @log << "Überspringe Eintrag #{i + 1}: #{title}/#{url} #{source.errors.full_messages.to_sentence}"
      end
    end
  end

  def opml
    @opml ||= OpmlFile.create(owner: owner, source: text)
  end
end
