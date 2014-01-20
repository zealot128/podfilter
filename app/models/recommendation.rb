class Recommendation < ActiveRecord::Base
  belongs_to :podcast
  belongs_to :owner
  scope :ordered, -> { order('weight desc') }
end
