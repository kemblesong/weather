# Converts bearings into cardinal directions.

class Cardinal
  def convert bearing
   if bearing < 0 && bearing > -180
     # Normalize to [0,360]
     bearing = 360.0 + bearing;
   end
   if bearing > 360 || bearing < -180
     return "Unknown"
   end

   directions = [
     "N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
     "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW",
     "N"]
   cardinal = directions[(((bearing + 11.25) % 360) / 22.5).floor];
   return cardinal
 end
end
