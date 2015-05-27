class WeatherDataController < ApplicationController
  def show_by_name
    @location = params[:location_id]
    @date = Date.parse(params[:date])
    @observations = Observation.where(location_id: Location.where(name: @location).first.id).where(observed_at: @date.beginning_of_day..@date.end_of_day)
    render :data
  rescue ActiveRecord::RecordNotFound
    render :not_found
  end

  def show_by_postcode
    @location = Location.where(postcode: params[:postcode]).first!.name
    @date = Date.parse(params[:date])
    @observations = Observation.where(location_id: Location.where(name: @location).first.id).where(observed_at: @date.beginning_of_day..@date.end_of_day)
    render :data
  rescue ActiveRecord::RecordNotFound
    render :not_found
  end
end
