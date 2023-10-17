class Api::V1::PlanetarySystemsController < ApplicationController 
  def index 
    render json: V1::PlanetarySystemSerializer.new(PlanetarySystem.all)
  end

  def show 
    render json: V1::PlanetarySystemSerializer.new(PlanetarySystem.find(params[:id]))
  end

  def create 
    
  end
end