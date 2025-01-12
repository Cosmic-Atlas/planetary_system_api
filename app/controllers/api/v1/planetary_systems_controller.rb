class Api::V1::PlanetarySystemsController < ApplicationController 
  def index 
    render json: V1::PlanetarySystemSerializer.new(PlanetarySystem.all), status: 200
  end

  def show 
    render json: V1::PlanetarySystemSerializer.new(PlanetarySystem.find(params[:id])), status: 200
  end

  def create 
    render json: V1::PlanetarySystemSerializer.new(PlanetarySystem.create!(planetary_system_params)), status: 201
  end

  def search_planetary_systems 
    render json: V1::PlanetarySystemSerializer.new(PlanetarySystem.search_records(params[:name])), status: 200
  end

  def system_planet_count 
    # require 'pry'; binding.pry
    # render json: V1::PlanetarySystemSerializer.new()
    #make method for planet count in model and test in model spec

  end

  private 
    def planetary_system_params 
      params.require(:planetary_system).permit(:name, :light_years_from_earth, :star_age)
    end
end