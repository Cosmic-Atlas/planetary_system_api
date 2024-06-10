class Api::V1::MoonsController < ApplicationController 
  def index 
    render json: V1::MoonSerializer.new(Moon.all), status: 200
  end

  def show 
    render json: V1::MoonSerializer.new(Moon.find(params[:id])), status: 200
  end

  def create 
    render json: V1::MoonSerializer.new(Moon.create!(moon_params)), status: 201
  end

  def by_planet # if moon.moonsbyplanet is [], then return error and status of 404
    planet = Moon.moons_by_planet(params[:moons_by_planet])
    # render json: V1::MoonSerializer.new(Moon.moons_by_planet(params[:moons_by_planet])), status: 200
    if planet != [] 
      render json: V1::MoonSerializer.new(planet), status: 200
    else 
      render json: ErrorSerializer.new("Planet not found").bad_request, status: 404
    end
    # require 'pry'; binding.pry
  end

  private 
    def moon_params 
      params.require(:moon).permit(:name, :radius_km, :rotational_period, :magnitude, :planet_id)
    end
end