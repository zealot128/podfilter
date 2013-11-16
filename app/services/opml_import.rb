class OpmlImport
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

end
