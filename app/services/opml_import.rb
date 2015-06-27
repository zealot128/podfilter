class OpmlImport
  BLACKLIST = [
    /railscasts.*subscriptions/
  ]
  attr_reader :owner, :log
  def initialize(file, owner)
    @file = file
    @owner = owner
    @log = []
  end

  def text
    @text ||= begin
                text = if @file.respond_to? :read
                         @file.read
                       else
                         @file
                       end
                if !text.valid_encoding?
                  @log << t('encoding_latin1')
                  text = text.force_encoding(Encoding::ISO8859_1).encode(Encoding::UTF_8)
                end
                text
              end
  end

  def run!
    if opml.new_record?
      @log << t('already_uploaded')
      return opml
    end
    update_sources(opml)
    owner.ignore_file
    opml
  end


  protected

  def t(string, args={})
    I18n.t("opml_import.#{string}", args)
  end

  def update_sources(opml_file)
    document = Nokogiri::XML.parse(opml_file.source)
    outlines = document.search('outline')
    if outlines.count ==0
      @log << t('no_entries_found')
      return
    end
    outlines.each_with_index do |outline,i|
      url = outline['url'] || outline['xmlUrl']
      next if url and BLACKLIST.any?{|r| url[r]}
      title = outline['title'] || outline['text']
      source = Source.where(url: url).first_or_initialize
      was_new_record = source.new_record?
      if source.save
        if source.opml_files.where('opml_file_id = ?', opml_file.id).count == 0
          @log << t('source_known', url: url)
          source.opml_files << opml_file
        end
        if was_new_record
          @log << t('source_unknown', url: url)
          SourceUpdateWorker.perform_async(source.id)
        end
      else
        @log << t('skip_entry', number: i+1, title: title, url: url, error: source.errors.full_messages.to_sentence)
      end
    end
  end

  def ignore_opml_file
    IgnoreFile.create(owner: owner, source: '', name: t('ignore_name'))
  end

  def opml
    date = I18n.l(Date.today)
    original_name = t('default_name', date: date)
    name = original_name
    i = 0
    while owner.opml_files.where(name: name).any? do
      name = original_name + " (#{i+=1})"
    end
    @opml ||= OpmlFile.create(owner: owner, source: text, name: name)
  end
end
