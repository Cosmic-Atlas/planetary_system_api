class Api::V1::PlanetarySystemsController < ApplicationController 
  def index 
    render json: PlanetarySystem.all
  end
end