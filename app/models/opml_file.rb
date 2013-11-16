class OpmlFile < ActiveRecord::Base
  has_and_belongs_to_many :sources
  belongs_to :owner
end
