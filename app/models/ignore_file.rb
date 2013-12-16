class IgnoreFile < OpmlFile
  def set_md5
    self.md5 = owner.id
  end
end
