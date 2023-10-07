require "rails_helper"

describe "Planetary Systems API" do 
  it "sends a list of planetary systems" do 
    create_list(:planetary_system, 3)

    get "/api/v1/planetary_systems"

    expect(response).to be_successful

    planetary_systems = JSON.parse(response.body, symbolize_names: true)
   
    expect(planetary_systems).to have_key(:data)
    expect(planetary_systems[:data].count).to eq(3)

    planetary_systems[:data].each do |system| 
      expect(system.keys).to match_array([:id, :type, :attributes])
      expect(system[:attributes].keys).to match_array([:name, :light_years_from_earth, :star_age])
    end
  end

  it "gets one planetary system information" do 
    planetary_system = create(:planetary_system)

    get "/api/v1/planetary_systems/#{planetary_system.id}"

    parsed_system = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful 

    expect(parsed_system[:data].keys).to match_array([:id, :type, :attributes])
    expect(parsed_system[:data][:attributes].keys).to match_array([:name, :light_years_from_earth, :star_age])
  end
end