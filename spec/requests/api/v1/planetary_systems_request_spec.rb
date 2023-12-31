require "rails_helper"

describe "Planetary Systems Requests" do
  describe "Requests" do
    before(:each) do 
      @planetary_system_1 = create(:planetary_system)
      @planetary_system_2 = create(:planetary_system)
      @planetary_system_3 = create(:planetary_system)
    end

    it "sends a list of planetary systems" do 


      get "/api/v1/planetary_systems"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      planetary_systems = JSON.parse(response.body, symbolize_names: true)
    
      expect(planetary_systems).to have_key(:data)
      expect(planetary_systems[:data].count).to eq(3)

      planetary_systems[:data].each do |system| 
        expect(system.keys).to match_array([:id, :type, :attributes])
        expect(system[:attributes].keys).to match_array([:name, :light_years_from_earth, :star_age])
        expect(system[:attributes][:name]).to be_a(String)
        expect(system[:attributes][:light_years_from_earth]).to be_a(Integer)
        expect(system[:attributes][:star_age]).to be_a(Integer)
      end
    end

    it "gets one planetary system information" do 

      get "/api/v1/planetary_systems/#{@planetary_system_1.id}"

      parsed_system = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_system[:data].keys).to match_array([:id, :type, :attributes])
      expect(parsed_system[:data][:attributes].keys).to match_array([:name, :light_years_from_earth, :star_age])
    end

    it "creates a new planetary system" do 
      system_params = ({
                          name: "Super System",
                          light_years_from_earth: 4,
                          star_age: 123456
                      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/planetary_systems", headers: headers, params: JSON.generate(planetary_system: system_params)

      created_system = PlanetarySystem.last 

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(created_system.name).to eq(system_params[:name])
      expect(created_system.light_years_from_earth).to eq(system_params[:light_years_from_earth])
      expect(created_system.star_age).to eq(system_params[:star_age])
      expect(PlanetarySystem.count).to eq(4)
    end

    it "capitalizes the planetary system is entered lowercase" do 
      system_params = ({
                          name: "super system",
                          light_years_from_earth: 4,
                          star_age: 123456
                      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/planetary_systems", headers: headers, params: JSON.generate(planetary_system: system_params)

      created_system = PlanetarySystem.last 

      expect(response).to be_successful
      expect(created_system.name).to_not eq(system_params[:name])
      expect(created_system.name).to eq("Super System")
    end
  end

   # *~* INVALID REQUESTS *~*
   
  describe "errors" do 
    before(:each) do 
      @planetary_system = create(:planetary_system)
    end

    it "returns an error if the system doesnt exist" do

      get "/api/v1/planetary_systems/75846"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["Couldn't find PlanetarySystem with 'id'=75846"])
    end

    it "returns an error if a letter is provided for id" do 
  
      get "/api/v1/planetary_systems/hey"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["Couldn't find PlanetarySystem with 'id'=hey"])
    end

    it "returns an error when a required value isnt provided to create" do 
      system_params = ({
                          light_years_from_earth: 4,
                          star_age: 123456
                      }) #name is not provided
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/planetary_systems", headers: headers, params: JSON.generate(planetary_system: system_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(PlanetarySystem.count).to eq(1)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["Validation failed: Name can't be blank"])
    end
  end
end