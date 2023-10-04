require "rails_helper"

describe "Planetary Systems API" do 
  it "sends a list of planetary systems" do 
    create_list(:planetary_system, 3)

    get "/api/v1/planetary_systems"

    expect(response).to be_successful
  end
end