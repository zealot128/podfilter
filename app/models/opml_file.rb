class OpmlFile < ActiveRecord::Base
  has_many :opml_files_sources, dependent: :destroy
  has_many :sources, through: :opml_files_sources
  has_many :podcasts, through: :sources
  belongs_to :owner

  validates :md5, uniqueness: { scope: :owner_id }
  validates :name, presence: true, uniqueness: { scope: :owner_id }

  before_create :randomize_id
  before_validation :set_md5

  scope :opml_files, -> { where type: 'OpmlFile' }
  scope :no_ignore, -> { where 'type is null or type != ?', 'IgnoreFile' }

  def to_s
    [name,md5].find(&:present?)
  end

  private

  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while OpmlFile.where(:id => self.id).exists?
  end

  def set_md5
    self.md5 = Digest::MD5.hexdigest(self.source || self.name)
  end

end
