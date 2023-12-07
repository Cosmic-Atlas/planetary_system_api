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
      @moon_4 - create(:moon, planet_id: @planet_3.id)
    end
  end
end