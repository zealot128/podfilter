class RandomImageGenerator
  def self.generate(string, scale: 10)
    image = Quilt::Identicon.new string, scale: scale
    tmp = Tempfile.new( [ 'quilt', ".png"])
    tmp.binmode
    tmp.write  image.to_blob
    tmp.rewind
    tmp
  end
end
