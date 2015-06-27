class Owner < ActiveRecord::Base
  has_many :opml_files
  has_many :identities
  belongs_to :primary_identity, class_name: 'Identity'
  has_many :sources, through: :opml_files
  has_many :podcasts, through: :sources
  mount_uploader :image, ImageUploader
  validate :only_100_owners_per_hour

  has_many :recommendations
  has_many :recommended_podcasts, through: :recommendations, source: :podcast


  before_validation do
    self.token ||= SecureRandom.hex(64)
    if self.image.blank?
      self.image = RandomImageGenerator.generate(token)
    end
  end

  before_create :randomize_id

  def only_token_user?
    token.present? and primary_identity.blank?
  end

  def to_s
    id.to_s
  end

  before_save do
    generate_api_key if !api_key
  end

  def generate_api_key
    begin
      self.api_key = SecureRandom.hex(64)
    end while Owner.where(api_key: api_key).exists?
  end

  def ignore_file
    opml_files.where(type: 'IgnoreFile').first || IgnoreFile.create(owner: self, source: '', name: 'Podcast Ignore-Liste')
  end

  private

  def only_100_owners_per_hour
    if Owner.where('created_at > ?', 1.hour.ago).count > 100
      errors.add(:base, 'es wurden schon zuviele neue Nutzer in der letzten Zeit angelegt. Bitte probiere es spaeter noch einmal')
    end
  end

  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while Owner.where(:id => self.id).exists?
  end

end
