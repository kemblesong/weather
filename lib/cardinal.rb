# Converts bearings into cardinal directions.

class Cardinal
  
  # http://stackoverflow.com/questions/29812871/convert-orientation-n-s-se-sse-etc-to-bearing-angle
  def self.cardinal_direction_to_degrees(s)
    h = {n: 0, ne: 45, e: 90, se: 135, s: 180, sw: 225, w: 270, nw: 315}
    return h[s.to_s.downcase.to_sym]
  end
end
