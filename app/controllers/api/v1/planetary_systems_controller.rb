class Api::V1::PlanetarySystemsController < ApplicationController 
  def index 
    render json: V1::PlanetarySystemSerializer.new(PlanetarySystem.all)
  end

  def show 
    render json: V1::PlanetarySystemSerializer.new(PlanetarySystem.find(params[:id]))
  end

  def create 
    render json: V1::PlanetarySystemSerializer.new(PlanetarySystem.create!(planetary_system_params))
  end

  private 
    def planetary_system_params 
      params.require(:planetary_system).permit(:name, :light_years_from_earth, :star_age)
    end
end