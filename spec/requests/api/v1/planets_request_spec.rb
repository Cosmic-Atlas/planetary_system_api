require "rails_helper"

describe "Planet Requests" do
  
  # *~* VALID REQUESTS *~*
  describe "Requests" do 
    before(:each) do 
      @planetary_system = create(:planetary_system)

      @planet_1 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: true, planet_type: "Gas Giant")
      @planet_2 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: true, planet_type: "Gas Giant")
      @planet_3 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: false, planet_type: "Terrestrial")
    end

    it "sends a list of planets" do 

      get "/api/v1/planets"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      planets = JSON.parse(response.body, symbolize_names: true)

      expect(planets).to have_key(:data)
      expect(planets[:data].count).to eq(3)

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

      get "/api/v1/planets/#{@planet_1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200) 

      parsed_planet = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_planet[:data].keys).to match_array([:id, :type, :attributes])
      expect(parsed_planet[:data][:attributes].keys).to match_array([:name, :planet_type, :year_discovered, :confirmed])
    end

    it "creates a planet" do 
  
      planet_params = ({
                          name: "Blue",
                          planet_type: "Big Round Planet",
                          year_discovered: 2000,
                          confirmed: true,
                          planetary_system_id: @planetary_system.id
                      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/planets", headers: headers, params: JSON.generate(planet: planet_params)

      created_planet = Planet.last 

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(created_planet.name).to eq(planet_params[:name])
      expect(created_planet.planet_type).to eq(planet_params[:planet_type])
      expect(created_planet.year_discovered).to eq(planet_params[:year_discovered])
      expect(created_planet.confirmed).to eq(planet_params[:confirmed])
    end

    it "capitalizes the planet name if entered lowercase" do 
    
      planet_params = ({
                          name: "blue",
                          planet_type: "Big Round Planet",
                          year_discovered: 2000,
                          confirmed: true,
                          planetary_system_id: @planetary_system.id
                      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/planets", headers: headers, params: JSON.generate(planet: planet_params)

      created_planet = Planet.last 

      expect(response).to be_successful
      expect(created_planet.name).to_not eq(planet_params[:name])
      expect(created_planet.name).to eq("Blue")
    end

    it "gets all the confirmed planets" do 

      get "/api/v1/planets/confirmed_planets"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      confirmed_planets = JSON.parse(response.body, symbolize_names: true)
      
      expect(confirmed_planets).to have_key(:data)
      expect(confirmed_planets[:data].count).to eq(2)
      
      confirmed_planet_ids = confirmed_planets[:data].map do |planet|
        planet[:id].to_i
      end

      expect(confirmed_planet_ids).to match_array([@planet_1.id, @planet_2.id])
    end

    it "gets all unconfirmed planets" do 

      get "/api/v1/planets/unconfirmed_planets"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      unconfirmed_planets = JSON.parse(response.body, symbolize_names: true)
      
      expect(unconfirmed_planets).to have_key(:data)
      expect(unconfirmed_planets[:data].count).to eq(1)
      
      unconfirmed_planet_ids = unconfirmed_planets[:data].map do |planet|
        planet[:id].to_i
      end

      expect(unconfirmed_planet_ids).to match_array([@planet_3.id])
    end

    it "gets the planets of the searched planet type" do 

      get "/api/v1/planets/planet_type/#{"?planet_type=Gas Giant"}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      gas_giants = JSON.parse(response.body, symbolize_names: true)

      expect(gas_giants[:data].count).to eq(2)

      gas_giant_ids = gas_giants[:data].map do |planet| 
        planet[:id].to_i
      end

      expect(gas_giant_ids).to match_array([@planet_1.id, @planet_2.id])
    end

    it "searches for a planet by name" do 
      get "/api/v1/planets/search_planets?name=#{@planet_1.name}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results).to have_key(:data)
      expect(search_results[:data]).to be_an(Array)
      expect(search_results[:data].count).to eq(1)
      expect(search_results[:data][0]).to have_key(:attributes)
      expect(search_results[:data][0]).to be_a(Hash)
      expect(search_results[:data][0][:attributes]).to have_key(:name)
      expect(search_results[:data][0][:attributes][:name]).to eq(@planet_1.name)
    end
  end

  # *~* INVALID REQUESTS *~*
  
  describe "errors" do 
    before(:each) do 
      @planetary_system = create(:planetary_system)

      @planet_1 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: true, planet_type: "Gas Giant")
      @planet_2 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: true, planet_type: "Terrestrial")
    end

    it "returns an error when the id does not exist for a planet" do 
      get "/api/v1/planets/4385"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["Couldn't find Planet with 'id'=4385"])
    end

    it "returns an error when letter is provided for id" do 
      get "/api/v1/planets/b"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["Couldn't find Planet with 'id'=b"])
    end

    it "returns an error when creating if a required value is not provided" do 
      planet_params = ({
                        name: "Blue",
                        year_discovered: 2000,
                        confirmed: true,
                        planetary_system_id: @planetary_system.id
                    }) #no planet_type provided
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/planets", headers: headers, params: JSON.generate(planet: planet_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["Validation failed: Planet type can't be blank"])
      expect(Planet.count).to eq(2)
    end
  end
end