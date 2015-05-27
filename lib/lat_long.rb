class LatLong
  R_EARTH = 6371
	def self.eval_distance l1, l2
    lat1  = l1[:latitude] 
    long1 = l1[:longitude]
    lat2  = l2[:latitude]
    long2 = l2[:longitude]
    return Math.acos( Math.sin(lat1)*Math.sin(lat2) + Math.cos(lat1)*Math.cos(lat2)*Math.cos(lon2-lon1) ) * R_EARTH
	end
end