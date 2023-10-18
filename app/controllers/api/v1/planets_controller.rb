class Api::V1::PlanetsController < ApplicationController 
  def index 
    render json: V1::PlanetSerializer.new(Planet.all)
  end

  def show 
    render json: V1::PlanetSerializer.new(Planet.find(params[:id]))  
  end

  def create 
    
  end
end