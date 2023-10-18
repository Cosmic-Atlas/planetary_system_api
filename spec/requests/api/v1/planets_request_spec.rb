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
    planetary_system = create(:planetary_system)
    planet_params = ({
                        name: "Blue",
                        planet_type: "Big Round Planet",
                        year_discovered: 2000,
                        confirmed: true,
                        planetary_system_id: planetary_system.id
                    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/planets", headers: headers, params: JSON.generate(planet: planet_params)

    created_planet = Planet.last 

    expect(response).to be_successful
    expect(created_planet.name).to eq(planet_params[:name])
    expect(created_planet.planet_type).to eq(planet_params[:planet_type])
    expect(created_planet.year_discovered).to eq(planet_params[:year_discovered])
    expect(created_planet.confirmed).to eq(planet_params[:confirmed])
  end

  it "capitalizes the planet name if entered lowercase" do 
    planetary_system = create(:planetary_system)
    planet_params = ({
                        name: "blue",
                        planet_type: "Big Round Planet",
                        year_discovered: 2000,
                        confirmed: true,
                        planetary_system_id: planetary_system.id
                    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/planets", headers: headers, params: JSON.generate(planet: planet_params)

    created_planet = Planet.last 

    expect(response).to be_successful
    expect(created_planet.name).to_not eq(planet_params[:name])
    expect(created_planet.name).to eq("Blue")
  end
end