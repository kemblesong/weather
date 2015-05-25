class Observation < ActiveRecord::Base
  belongs_to :location
  has_one :measurement
end
