require "rails_helper"

describe "Planet Requests" do
  it "sends a list of planets" do 
    very_cool_planetary_system = create(:planetary_system)
    
    planet_1 = create(:planet, planetary_system_id: very_cool_planetary_system.id)
    planet_2 = create(:planet, planetary_system_id: very_cool_planetary_system.id)

    get "/api/v1/planets"

    expect(response).to be_successful
  end
end