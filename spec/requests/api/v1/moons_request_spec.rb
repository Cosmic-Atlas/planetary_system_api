require "rails_helper"

describe "Moons Requests" do 

  # *~* VALID REQUESTS *~*
  describe "Requests" do 
    before(:each) do 
      @planetary_system = create(:planetary_system)

      @planet_1 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: true, planet_type: "Gas Giant", name: "First Planet")
      @planet_2 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: true, planet_type: "Gas Giant")
      @planet_3 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: false, planet_type: "Terrestrial")

      @moon_1 = create(:moon, planet_id: @planet_1.id)
      @moon_2 = create(:moon, planet_id: @planet_1.id)
      @moon_3 = create(:moon, planet_id: @planet_2.id)
      @moon_4 = create(:moon, planet_id: @planet_3.id)
    end

    it "gets a list of moons" do 
      get "/api/v1/moons"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      moons = JSON.parse(response.body, symbolize_names: true)

      expect(moons).to have_key(:data)
      expect(moons[:data].count).to eq(4)

      moons[:data].each do |moon|
        expect(moon.keys).to match_array([:id, :type, :attributes])
        expect(moon[:attributes].keys).to match_array([:name, :radius_km, :rotational_period, :magnitude])
        expect(moon[:attributes][:name]).to be_a(String)
        expect(moon[:attributes][:radius_km]).to be_an(Integer)
        expect(moon[:attributes][:rotational_period]).to be_a(Float)
        expect(moon[:attributes][:magnitude]).to be_a(Float)
      end
    end

    it "gets one moon" do 
      get "/api/v1/moons/#{@moon_1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)
      parsed_moon = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_moon[:data].keys).to match_array([:id, :type, :attributes])
      expect(parsed_moon[:data][:attributes].keys).to match_array([:name, :radius_km, :rotational_period, :magnitude])
    end

    it "creates a moon" do 
      moon_params = ({
                        name: "Cool Moon",
                        radius_km: 1234, 
                        rotational_period: 15.0, 
                        magnitude: 1.03,
                        planet_id: @planet_1.id
      })

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/moons", headers: headers, params: JSON.generate(moon: moon_params)

      created_moon = Moon.last

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(created_moon.name).to eq(moon_params[:name])
      expect(created_moon.radius_km).to eq(moon_params[:radius_km])
      expect(created_moon.rotational_period).to eq(moon_params[:rotational_period])
      expect(created_moon.magnitude).to eq(moon_params[:magnitude])
    end

    it "gets a list of moons for a specific planet" do 
      get "/api/v1/moons/moons_by_planet/?moons_by_planet=#{@planet_1.name}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      moons_results = JSON.parse(response.body, symbolize_names: true)

      wanted_moons_ids = [@moon_1.id, @moon_2.id]

      moon_results_ids = moons_results[:data].map do |moon| 
        moon[:id].to_i
      end

      expect(moons_results[:data].count).to eq(2) # this failed once, result: 3
        #possible planet_1 and planet_2 had same name created automatically, so it was counting 3
        #moons for the same name. May want to change this to check for planet id as well
        #currently fixed by changing the name of the planet_1 to First Planet.
      expect(moon_results_ids).to match_array(wanted_moons_ids)

    end
  end

  # *~* INVALID REQUESTS *~*

  describe "errors" do 
    before(:each) do 
      @planetary_system = create(:planetary_system)

      @planet_1 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: true, planet_type: "Gas Giant")
      @planet_2 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: true, planet_type: "Gas Giant")

      @moon_1 = create(:moon, planet_id: @planet_1.id)
      @moon_2 = create(:moon, planet_id: @planet_1.id)
      @moon_3 = create(:moon, planet_id: @planet_2.id)

    end

    it "returns an error when id does not exist for a moon" do 
      get "/api/v1/moons/4567"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["Couldn't find Moon with 'id'=4567"])
    end

    it "returns an error when a letter is provided for id" do 
      get "/api/v1/moons/h"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["Couldn't find Moon with 'id'=h"])

    end

    it "returing an error when creating of required value is not provided" do 
      moon_params = ({
                        name: "Cool Moon",
                        #radius_km: 1234, no radius provided
                        rotational_period: 15.0, 
                        magnitude: 1.03,
                        planet_id: @planet_1.id
      })

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/moons", headers: headers, params: JSON.generate(moon: moon_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to eq(["Validation failed: Radius km can't be blank"])
      expect(Moon.count).to eq(3)
    end

    it "returns an error when searching for moons for a planet that doesnt exist" do 
      get "/api/v1/moons/moons_by_planet/?moons_by_planet=planot"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)
      # require 'pry'; binding.pry

      expect(error[:errors][0]).to eq("Planet not found")
    end
  end
end