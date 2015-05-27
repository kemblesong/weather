class LocationsController < ApplicationController
  def show
    @locations = Location.all
    render :locations
  end
end
