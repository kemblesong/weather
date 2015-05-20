# Fetches current weather data from sources and stores it in the database
require 'scraper'

class Fetcher
  def fetch source_name
    time = TimeStamp.create(timestamp: Time.now.to_i)
    scraper = Scraper.new
    source = Source.find_by(name: source_name)

    if source.format == 'html'
      location = Location.all
      location.each do |l|
        data = scraper.get_bom(l.name)
        obs = Observation.new
        obs.temperature = data[:temperature]
        obs.dew_point = data[:dew_point]
        obs.rainfall = data[:rainfall]
        obs.wind_direction = data[:wind_dir]
        obs.wind_speed = data[:wind_speed]
        obs.source_id = source.id
        obs.location_id = l.id
        obs.time_stamp_id = time.id
        obs.save
      end
    elsif source.format == 'json'
      location = Location.all
      location.each do |l|
        data = scraper.get_forecastio(time.timestamp, l.latitude, l.longitude)
        obs = Observation.new
        obs.temperature = data[:temperature]
        obs.dew_point = data[:dew_point]
        obs.rainfall = data[:rainfall]
        obs.wind_direction = data[:wind_dir]
        obs.wind_speed = data[:wind_speed]
        obs.source_id = source.id
        obs.location_id = l.id
        obs.time_stamp_id = time.id
        obs.save
      end

    end
  end
end
