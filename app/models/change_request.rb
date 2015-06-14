class ChangeRequest < ActiveRecord::Base
  belongs_to :owner

  validates :owner_id, presence: true
  store_accessor :payload, :email
  store_accessor :payload, :comment
  scope :uncompleted, -> { where(completed: [ nil, false ]) }

  before_create do
    self.token = SecureRandom.hex(32)
  end

  def self.types
    Dir['app/models/change_requests/*'].map{|i| i.split('/')[-2..-1].join('/').gsub('.rb','').camelcase}
  end

  def apply!
    self.update_column :completed, true
    self.update_column :token, nil

    if email.present?
      ChangeRequestMailer.notify(self).deliver
    end
  end

  def prefill(params)
  end

  def to_partial_path
    self.class.model_name.i18n_key.to_s
  end

  def self.permit(params)
    params.require(:change_request).permit(:email, :comment)
  end
end
