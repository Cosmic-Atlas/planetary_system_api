class Api::V1::PlanetsController < ApplicationController 
  def index 
    render json: V1::PlanetSerializer.new(Planet.all)
  end

  def show 
    render json: V1::PlanetSerializer.new(Planet.find(params[:id]))  
  end

  def create 
    render json: V1::PlanetSerializer.new(Planet.create!(planet_params))
  end

  def confirmed_planets
    render json: V1::PlanetSerializer.new(Planet.confirmed_planets)
  end

  def unconfirmed_planets 
    render json: V1::PlanetSerializer.new(Planet.unconfirmed_planets)
  end

  def by_planet_type 
    render json: V1::PlanetSerializer.new(Planet.filter_planet_type(params[:planet_type]))
  end

  private 
    def planet_params 
      params.require(:planet).permit(:name, :planet_type, :year_discovered, :confirmed, :planetary_system_id)
    end
end