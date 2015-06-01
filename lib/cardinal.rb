# Converts bearings into cardinal directions.

class Cardinal
  
  # adapted from http://stackoverflow.com/questions/29812871/convert-orientation-n-s-se-sse-etc-to-bearing-angle
  # we add more cardinal direction
  def self.to_degree(s)
    h = {n: 0, nne: 22.5, ne: 45, ene: 67.5, 
          e: 90, ese:112.5, se: 135, sse: 157.5, 
          s: 180, ssw: 202.5, sw: 225, wsw: 247.5, 
          w: 270, wnw: 292.5, nw: 315, nnw: 337.5}
    return h[s.to_s.downcase.to_sym]
  end
  
	# adapted from http://stackoverflow.com/questions/13220367/cardinal-wind-direction-from-degrees
	# original code by Martin R, written in Objective C
	# convert from degree (N at 0) to cardinal
	def self.from_degree(degree)
    directions = %w(N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW)
    i = (degree + 11.25)/22.5
    return directions[i%16]
  end
  
end
