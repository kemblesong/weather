class WeatherPredictionController < ApplicationController

  def postcode
    postcode = params[:postcode]
    period = params[:period]

    location = Location.find_by postcode: postcode

    @result = Hash.new
    @result['post_code'] = postcode

    if !location.nil?
      @result['predictions'] = Predict.regress Location.get_observations(location), period.to_i
    else
      # we don't have location for the given post code
      @result['predictions'] = Hash.new
    end

    respond_to do |format|
      format.html
      format.json { render json: @result.to_json }
    end
  end

end
