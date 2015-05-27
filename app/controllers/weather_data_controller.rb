class WeatherDataController < ApplicationController
  def show_by_name
    @location = params[:location_id]
    @observations = Observation.where(location_id: Location.find(name: params[:location_id]).id).where(Time.at(observed_at).to_date == params[:date])
    render :data
  rescue ActiveRecord::RecordNotFound
    render :not_found
  end

  def show_by_postcode

  end
end
