class Observation < ActiveRecord::Base
  belongs_to :location
  belongs_to :source
  belongs_to :time_stamp
end
