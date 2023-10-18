require "rails_helper"

describe "Planet Requests" do
  it "sends a list of planets" do 
    very_cool_planetary_system = create(:planetary_system)
    
    planet_1 = create(:planet, planetary_system_id: very_cool_planetary_system.id)
    planet_2 = create(:planet, planetary_system_id: very_cool_planetary_system.id)

    get "/api/v1/planets"

    expect(response).to be_successful

    planets = JSON.parse(response.body, symbolize_names: true)

    expect(planets).to have_key(:data)
    expect(planets[:data].count).to eq(2)

    planets[:data].each do |planet|
      expect(planet.keys).to match_array([:id, :type, :attributes])
      expect(planet[:attributes].keys).to match_array([:name, :planet_type, :year_discovered, :confirmed])
      expect(planet[:attributes][:name]).to be_a(String)
      expect(planet[:attributes][:planet_type]).to be_a(String)
      expect(planet[:attributes][:year_discovered]).to be_a(Integer)
      expect(planet[:attributes][:confirmed]).to be_in([true, false])
    end
  end

  it "gets one planet information" do 
    very_cool_planetary_system = create(:planetary_system)
    
    planet_1 = create(:planet, planetary_system_id: very_cool_planetary_system.id)

    get "/api/v1/planets/#{planet_1.id}"

    expect(response).to be_successful 

    parsed_planet = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_planet[:data].keys).to match_array([:id, :type, :attributes])
    expect(parsed_planet[:data][:attributes].keys).to match_array([:name, :planet_type, :year_discovered, :confirmed])
  end

  it "creates a planet" do 
    planet_params = ({
                        name: "super system",
                        light_years_from_earth: 4,
                        star_age: 123456
                    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/planets", headers: headers, params: JSON.generate(planetary_system: planet_params)

    created_system = PlanetarySystem.last 

  end
end