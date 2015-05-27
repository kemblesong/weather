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

  # Get weather prediction by latitude and longitude and return the results.
  def self.get_prediction_by_lat_long(lat, long, period)
    # Search the latitude and longitude in the database.
    location = Location.where(latitude: lat, longitude: long).first

    # If there is no location matches the latitude and longitude, get the closest weather station within 15km.
    location = LatLong.get_closest_station(lat, long, Location.all) if location.nil?

    # Build the result.
    result = Hash.new
    result['latitude'] = lat
    result['longitude'] = long

    result['predictions'] = location.nil? ? Hash.new : Predict.regress(Location.get_observations(location), period.to_i)

    result
  end


end
