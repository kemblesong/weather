class LatLong
  # The radius of the earth.
  R_EARTH = 6371

  # Get the distance between two coordinates.
	def self.eval_distance(l1, l2)
    lat1 = l1['latitude'] * Math::PI / 180
    long1 = l1['longitude'] * Math::PI / 180
    lat2 = l2['latitude'] * Math::PI / 180
    long2 = l2['longitude'] * Math::PI / 180

    Math.acos(Math.sin(lat1)*Math.sin(lat2) + Math.cos(lat1)*Math.cos(lat2)*Math.cos(long2-long1)) * R_EARTH
  end

  # Get the closest weather station to the given latitude/longitude within 1000km from the locations.
  def self.get_closest_station(lat, long, locations)
    position = Hash.new
    position['latitude'] = lat.to_f
    position['longitude'] = long.to_f

    min_dist = R_EARTH
    target_location = nil

    # Compare the distance between the given location and every weather station.
    locations.each do |loc|
      l_position = Hash.new
      l_position['latitude'] = loc.latitude
      l_position['longitude'] = loc.longitude
      dist = eval_distance(position, l_position)

      # If the distance is larger than 15km, do not use it.
      if dist < min_dist && dist <= 15
        min_dist = dist
        target_location = loc
      end
    end

    target_location
  end
end