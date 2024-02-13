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

    it "searches for a planetary_system, no result returns all planets" do 
      get "/api/v1/planetary_systems/search_planetary_systems/#{"earth"}" 
      #no earth present, endpoint should return all planets in database

      expect(response).to be_successful
      # expect(response.status).to eq(200)

      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results).to have_key(:data)
      expect(search_results[:data]).to be_an(Array)

      expect(search_results[:data].count).to eq(3)

      search_results_ids = search_results[:data].map do |result| 
        result[:id].to_i
      end

      expect(search_results_ids).to match_array([@planetary_system_1.id, @planetary_system_2.id, @planetary_system_3.id])
    end

    it "searches for an eisting planetary system, matching result returns that system" do 
      # get "/api/v1/planetary_systems/search_planetary_systems/#{@planetary_system_1.name}"

      get "/api/v1/planetary_systems/search_planetary_systems?name=#{@planetary_system_1.name}"
      
      #seems to be a 'bad uri' when there is a space in the name
      #fixed? I think

      expect(response).to be_successful
      # expect(response.status).to eq(200)

      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results).to have_key(:data)
      expect(search_results[:data]).to be_an(Array)
      expect(search_results[:data][0]).to have_key(:attributes)
      expect(search_results[:data][0]).to be_a(Hash)
      expect(search_results[:data][0][:attributes]).to have_key(:name)
      expect(search_results[:data][0][:attributes][:name]).to eq(@planetary_system_1.name)
      # require 'pry'; binding.pry
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