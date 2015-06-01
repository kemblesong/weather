class LocationsController < ApplicationController
  def show
    @locations = Location.all
    @results = Hash.new
    @results['date'] = Time.now.strftime('%d-%m-%Y')
    @results['locations'] = Array.new
    @locations.each do |l|
      @results['locations'] << {
        'id' => l.name,
        'lat' => l.latitude,
        'lon' => l.longitude,
        'last_update' => Time.at(Observation.where(location_id: l.id).order(observed_at: :desc).first.observed_at).strftime('%H:%M%P %d-%m-%Y')
      }
    end
    respond_to do |format|
      format.html {render :locations}
      format.json {render json: @results.to_json}
    end
  end
end
