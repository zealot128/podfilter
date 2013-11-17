class Recommendation < ActiveRecord::Base
  belongs_to :source
  belongs_to :owner
  scope :ordered, -> { order('weight desc') }
end
