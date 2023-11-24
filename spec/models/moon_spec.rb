require "rails_helper"

RSpec.describe Moon do 
  let!(:luna) {Moon.create!(name: "Luna", radius_km: 1737, rotational_period: 27, magnitude: -12.74)}

  
end