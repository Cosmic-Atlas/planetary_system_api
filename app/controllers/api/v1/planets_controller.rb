class Api::V1::PlanetsController < ApplicationController 
  def index 
    render json: V1::PlanetSerializer.new(Planet.all), status: 200
  end

  def show 
    render json: V1::PlanetSerializer.new(Planet.find(params[:id])), status: 200  
  end

  def create 
    render json: V1::PlanetSerializer.new(Planet.create!(planet_params)), status: 201
  end

  def confirmed_planets
    render json: V1::PlanetSerializer.new(Planet.confirmed_planets), status: 200
  end

  def unconfirmed_planets 
    render json: V1::PlanetSerializer.new(Planet.unconfirmed_planets), status: 200
  end

  def by_planet_type 
    render json: V1::PlanetSerializer.new(Planet.filter_planet_type(params[:planet_type])), status: 200
  end

  private 
    def planet_params 
      params.require(:planet).permit(:name, :planet_type, :year_discovered, :confirmed, :planetary_system_id)
    end
end