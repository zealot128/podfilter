class OpmlFile < ActiveRecord::Base
  has_many :opml_files_sources
  has_many :sources, through: :opml_files_sources
  belongs_to :owner

  validates :md5, uniqueness: { scope: :owner_id }

  before_create :randomize_id

  def to_s
    [name,md5].find(&:present?)
  end

  private
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while OpmlFile.where(:id => self.id).exists?
  end

  before_validation do
    self.md5 = Digest::MD5.hexdigest(self.source || self.name)
  end


end
