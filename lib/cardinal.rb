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
end
