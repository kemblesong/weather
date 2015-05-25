# Scraper class that contains functions for scraping weather data from various
# sources. Each function returns a hash of requested data. Extend as necessary.


require 'nokogiri'
require 'open-uri'
require 'json'
require 'cardinal'

class Scraper

  def get_bom location
    url = 'http://www.bom.gov.au/vic/observations/vicall.shtml'
    doc = Nokogiri::HTML(open(url))
    data = doc.xpath('//td[contains(@headers, \''+location+'\')]').map{|x| x.text}
    forecast = { temperature: data[1],
                 rainfall: data[12],
                 wind_dir: data[6],
                 wind_speed: data[7] }
    return forecast
  end
end
