# Scraper class that contains functions for scraping weather data from various
# sources. Each function returns a hash of requested data. Extend as necessary.


require 'nokogiri'
require 'open-uri'
require 'json'
require 'cardinal'

class Scraper

  def get_forecastio time, lat, long
    api_key = '0a73fa455425979752f12c2afe2441ba'
    base_url = 'https://api.forecast.io/forecast'
    data = JSON.parse(open("#{base_url}/#{api_key}/#{lat},#{long},#{time}?units=si&exclude=minutely,hourly,daily,flags,alerts").read)['currently']
    forecast = { temperature: data['temperature'],
                 dew_point: data['dewPoint'],
                 rainfall: data['precipIntensity'],
                 wind_dir: Cardinal.new.convert(data['windBearing']),
                 wind_speed: data['windSpeed'] }
    return forecast
  end

  def get_bom location
    url = 'http://www.bom.gov.au/vic/observations/melbourne.shtml'
    doc = Nokogiri::HTML(open(url))
    data = doc.xpath('//td[contains(@headers, \''+location+'\')]').map{|x| x.text}
    forecast = { temperature: data[1],
                 dew_point: data[3],
                 rainfall: data[12],
                 wind_dir: data[6],
                 wind_speed: data[7] }
    return forecast
  end

end
