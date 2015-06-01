class WeatherDataController < ApplicationController
  def show_by_name
    @location = params[:location_id]
    @date = Date.parse(params[:date])
    @observations = Observation.where(location_id: Location.where(name: @location).first.id).where(observed_at: @date.beginning_of_day..@date.end_of_day)
    @results = Hash.new
    @results['date'] = @date
    @results['current_temp'] = Predict.get_current_temp(Location.where(name: @location).first)
    @results['current_cond'] = Predict.get_current_cond(Location.where(name: @location).first)
    @results['measurements'] = Array.new
    @observations.each do |o|
      @results['measurements'] << {
        'time' => Time.at(o.observed_at).strftime('%H:%M:%S %P'),
        'temp' => o.get_measurement.temperature,
        'precip' => o.get_measurement.rainfall,
        'wind_direction' => Cardinal.from_degree(o.get_measurement.wind_direction),
        'wind_speed' => o.get_measurement.wind_speed
      }
    end
    respond_to do |format|
      format.html {render :data_by_name}
      format.json {render json: @results.to_json}
    end
  rescue ActiveRecord::RecordNotFound
    render :not_found
  end

  def show_by_postcode
    @locations = Location.where(postcode: params[:postcode])
    @date = Date.parse(params[:date])
    @results = Hash.new
    @results['date'] = @date
    @results['locations'] = Array.new
    @locations.each do |l|
      @observations = Observation.where(location_id: Location.where(name: l.name).first.id).where(observed_at: @date.beginning_of_day..@date.end_of_day)
      @measurements = Array.new
      @observations.each do |o|
        @measurements << {
          'time' => Time.at(o.observed_at).strftime('%H:%M:%S %P'),
          'temp' => o.get_measurement.temperature,
          'precip' => o.get_measurement.rainfall,
          'wind_direction' => Cardinal.from_degree(o.get_measurement.wind_direction),
          'wind_speed' => o.get_measurement.wind_speed
        }
      end
      @results['locations'] << {
        'id' => l.name,
        'lat' => l.latitude,
        'lon' => l.longitude,
        'last_update' => Time.at(Observation.where(location_id: l.id).order(observed_at: :desc).first.observed_at).strftime("%H:%M%P %d-%m-%Y"),
        'measurements' => @measurements
      }
    end

    respond_to do |format|
      format.html {render :data_by_postcode}
      format.json {render json: @results.to_json}
    end
  rescue ActiveRecord::RecordNotFound
    render :not_found
  end
end
