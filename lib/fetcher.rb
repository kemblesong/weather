# Fetches current weather data from sources and stores it in the database
require 'scraper'

class Fetcher
  def fetch
    scraper = Scraper.new
    location = Location.all
    location.each do |l|
      data = scraper.get_bom(l.name)
      observation = Observation.new
      measurement = Measurement.new
      measurement.temperature = data[:temperature]
      measurement.rainfall = data[:rainfall]
      measurement.wind_direction = data[:wind_dir]
      measurement.wind_speed = data[:wind_speed]
      measurement.save
      observation.location_id = l.id
      observation.measurement_id = measurement.id
      observation.observed_at = Time.now.to_i
    end
  end
end
