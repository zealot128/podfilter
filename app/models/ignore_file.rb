class IgnoreFile < OpmlFile
  def set_md5
    self.md5 = owner.id
  end
  def self.model_name
    OpmlFile.model_name
  end
end
