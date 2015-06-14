class Identity < ActiveRecord::Base
  belongs_to :owner
  mount_uploader :image, ImageUploader

  def to_s
    "#{name}-#{uid}@#{provider}"
  end
end
