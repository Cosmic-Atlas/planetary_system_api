class Api::V1::MoonsController < ApplicationController 
  def index 
    render json: V1::MoonSerializer.new(Moon.all)
  end
end