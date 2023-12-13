require "rails_helper"

describe "Moons Requests" do 
  describe "Requests" do 
    before(:each) do 
      @planetary_system = create(:planetary_system)

      @planet_1 = create(:planet, planetary_system_id: @planetary_system.id, confirmed: true, planet_type: "Gas Giant")
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
      # expect(response.status).to eq(200)
      #Add tests to parse JSON and serializer file

      moons = JSON.parse(response.body, symbolize_names: true)

      expect(moons).to have_key(:data)
      expect(moons[:data].count).to eq(4)

      moons[:data].each do |moon|
        expect(moon.keys).to match_array([:id, :type, :attributes])
        expect(moon[:attributes].keys).to match_array([:name, :radius_km, :rotational_period, :magnitude])
        expect(moon[:attributes][:name]).to be_a(String)
        expect(moon[:attributes][:radius_km]).to be_an(Integer)
        expect(moon[:attributes][:rotational_period]).to be_an(Integer)
        expect(moon[:attributes][:magnitude]).to be_a(Float)
      end
    end

    it "gets one moon" do 
      get "/api/v1/moons/#{@moon_1.id}"

      expect(response).to be_successful
      #expect(response.status).to eq(200)
    end
  end
end