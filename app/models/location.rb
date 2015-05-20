class Location < ActiveRecord::Base
  has_many :observations
end
