class Location < ActiveRecord::Base
  has_many :observations
  
  def self.get_observations location
    # result = Array.new
#     observations = Observation.all
#     observations.each do |o|
#       if o.location_id == location.id
#         result += [o]
#       end
#     end
#     return result
    return Observation.where(location_id: location.id)
  end
end
