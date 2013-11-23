class OpmlFile < ActiveRecord::Base
  has_and_belongs_to_many :sources
  belongs_to :owner

  validates :md5, uniqueness: { scope: :owner_id }
  validates :source, presence: true

  before_create :randomize_id

  def to_s
    md5
  end
  private
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while OpmlFile.where(:id => self.id).exists?
  end

  before_validation do
    self.md5 = Digest::MD5.hexdigest(self.source)
  end


end
