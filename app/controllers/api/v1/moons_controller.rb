class Api::V1::MoonsController < ApplicationController 
  def index 
    render json: V1::MoonSerializer.new(Moon.all)
  end

  def show 
    render json: V1::MoonSerializer.new(Moon.find(params[:id]))
  end

  def create 
    render json: V1::MoonSerializer.new(Moon.create!(moon_params))
  end

  private 
    def moon_params 
      params.require(:moon).permit(:name, :radius_km, :rotational_period, :magnitude, :planet_id)
    end
end