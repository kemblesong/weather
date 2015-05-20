class WeatherController < ApplicationController
  def show
    @times = TimeStamp.all.order(timestamp: :desc)
    render :data
  end
end
