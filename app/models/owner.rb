class Owner < ActiveRecord::Base
  before_create do
    self.token = SecureRandom.hex(127)
  end
end
