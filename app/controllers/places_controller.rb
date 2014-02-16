class PlacesController < ApplicationController
  before_action :set_place, only: [:show]
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def show
    @place = set_place(params[:city])
    render 'places/show'
  end

  private

  def set_place(params[:city])
    places = set_places(params[:city])
    @place = places.find(params[:id])
  end

  def set_places(city)
    @places = BeermappingApi.places_in(params[:city])
  end
end