require "rails_helper"

RSpec.describe Planet do 
   before(:each) do 
    @solar_system = PlanetarySystem.create!(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)
  
    @mars = Planet.create!(name: "Mars", planet_type: "Terrestrial", year_discovered: 1610, confirmed: true, planetary_system_id: @solar_system.id)
    @pluto = Planet.create(name: "Pluto", planet_type: "Dwarf", year_discovered: 1930, confirmed: false, planetary_system_id: @solar_system.id)
    @saturn = Planet.create(name: "Saturn", planet_type: "Gas Giant", year_discovered: 1610, confirmed: true, planetary_system_id: @solar_system.id)
  end

  describe '#attributes' do 
    it 'has a name, type, year discovered and confirmed' do 
      expect(@mars.name).to eq("Mars")
      expect(@mars.planet_type).to eq("Terrestrial")
      expect(@mars.year_discovered).to eq(1610)
      expect(@mars.confirmed).to eq(true)

      expect(@mars.planetary_system_id).to eq(@solar_system.id)
    end
  end

  describe 'associations' do 
    it {should belong_to :planetary_system}
  end

  describe 'validations' do 
    it 'should be valid' do 
      mars_ish = Planet.create(name: nil, planet_type: "Terrestrial", year_discovered: 1610, confirmed: true, planetary_system_id: @solar_system.id)
      mars_no_type = Planet.create(name: "Mars", planet_type: nil, year_discovered: 1610, confirmed: true, planetary_system_id: @solar_system.id)
      mars_no_year = Planet.create(name: "Mars", planet_type: "Terrestrial", year_discovered: nil, confirmed: true, planetary_system_id: @solar_system.id)
      mars_no_confirm = Planet.create(name: "Mars", planet_type: "Terrestrial", year_discovered: 1610, confirmed: nil, planetary_system_id: @solar_system.id)

      expect(@mars).to be_valid 
      expect(mars_ish).to_not be_valid
      expect(mars_no_type).to_not be_valid
      expect(mars_no_year).to_not be_valid
      expect(mars_no_confirm).to_not be_valid

    end

    it "should save the planet name capitalized if entered with a lowercase" do 
      expect(@mars.name).to eq("Mars")
    end
  end
end