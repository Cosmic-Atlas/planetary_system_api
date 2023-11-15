require "rails_helper"

RSpec.describe Planet do 

  let!(:solar_system) {PlanetarySystem.create!(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000, created_at: Time.now)}

  let!(:neptune) {Planet.create(name: "Neptune", planet_type: "Ice Giant", year_discovered: 1846, confirmed: true, planetary_system_id: solar_system.id)}
  let!(:pluto) {Planet.create(name: "Pluto", planet_type: "Dwarf", year_discovered: 1930, confirmed: false, planetary_system_id: solar_system.id)}
  let!(:mercury) {Planet.create(name: "Mercury", planet_type: "Terrestrial", year_discovered: 1631, confirmed: true, planetary_system_id: solar_system.id)}
  let!(:mars) {Planet.create!(name: "Mars", planet_type: "Terrestrial", year_discovered: 1610, confirmed: true, planetary_system_id: solar_system.id)}
  let!(:saturn) {Planet.create(name: "Saturn", planet_type: "Gas Giant", year_discovered: 1610, confirmed: true, planetary_system_id: solar_system.id)}
  let!(:jupiter) {Planet.create(name: "Jupiter", planet_type: "Gas Giant", year_discovered: 1610, confirmed: true, planetary_system_id: solar_system.id)}

  # before(:each) do 
  #   @solar_system = PlanetarySystem.create!(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)
  
  #   @mars = Planet.create!(name: "Mars", planet_type: "Terrestrial", year_discovered: 1610, confirmed: true, planetary_system_id: @solar_system.id)
  #   @pluto = Planet.create(name: "Pluto", planet_type: "Dwarf", year_discovered: 1930, confirmed: false, planetary_system_id: @solar_system.id)
  #   @saturn = Planet.create(name: "Saturn", planet_type: "Gas Giant", year_discovered: 1610, confirmed: true, planetary_system_id: @solar_system.id)
  #   @jupiter = Planet.create(name: "Jupiter", planet_type: "Gas Giant", year_discovered: 1610, confirmed: true, planetary_system_id: @solar_system.id)
  # end

  describe '#attributes' do 
    it 'has a name, type, year discovered and confirmed' do 
      expect(mars.name).to eq("Mars")
      expect(mars.planet_type).to eq("Terrestrial")
      expect(mars.year_discovered).to eq(1610)
      expect(mars.confirmed).to eq(true)

      expect(mars.planetary_system_id).to eq(solar_system.id)
    end
  end

  describe 'associations' do 
    it {should belong_to :planetary_system}
  end

  describe 'validations' do 
    it 'should be valid' do 
      mars_ish = Planet.create(name: nil, planet_type: "Terrestrial", year_discovered: 1610, confirmed: true, planetary_system_id: solar_system.id)
      mars_no_type = Planet.create(name: "Mars", planet_type: nil, year_discovered: 1610, confirmed: true, planetary_system_id: solar_system.id)
      mars_no_year = Planet.create(name: "Mars", planet_type: "Terrestrial", year_discovered: nil, confirmed: true, planetary_system_id: solar_system.id)
      mars_no_confirm = Planet.create(name: "Mars", planet_type: "Terrestrial", year_discovered: 1610, confirmed: nil, planetary_system_id: solar_system.id)

      expect(mars).to be_valid 
      expect(mars_ish).to_not be_valid
      expect(mars_no_type).to_not be_valid
      expect(mars_no_year).to_not be_valid
      expect(mars_no_confirm).to_not be_valid

    end

    it "should save the planet name capitalized if entered with a lowercase" do 
      expect(mars.name).to eq("Mars")
    end
  end

  describe '#confirmed_planets' do 
    it 'only shows true records' do 
      expect(Planet.confirmed_planets).to eq([neptune, mercury, mars, saturn, jupiter]) #neptune and mercury
    end
  end

  xdescribe "#unconfirmed_planets" do 
    it "only shows false records" do 
      expect(Planet.unconfirmed_planets).to eq([@pluto])
    end
  end

  xdescribe "#filter_planet_type" do 
    it "collects all planets by their type" do 
      expect(Planet.filter_planet_type("Gas Giant")).to match_array([@saturn, @jupiter])
      expect(Planet.filter_planet_type("Dwarf")).to eq([@pluto])
      expect(Planet.filter_planet_type("Terrestrial")).to eq([@mars]) # mercury
      #add ice giant neptune test
    end

    it "can search if entered lowercase" do 
      expect(Planet.filter_planet_type("terrestrial")).to eq([@mars]) #mercury
    end
  end

  xdescribe '::search_planet_records' do 
    it 'searched the planets by exact name' do 
      the_solar_system = PlanetarySystem.create(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)
      neptune = Planet.create(name: "Neptune", planet_type: "Ice Giant", year_discovered: 1846, confirmed: true, planetary_system_id: the_solar_system.id)
      mercury = Planet.create(name: "Mercury", planet_type: "Terrestrial", year_discovered: 1631, confirmed: true, planetary_system_id: the_solar_system.id)  

      expect(Planet.search_planet_records("Neptune")).to match_array([neptune])
      expect(Planet.search_planet_records("Neptnot")).to match_array(Planet.all)
      expect(Planet.search_planet_records(nil)).to match_array(Planet.all)
      expect(Planet.search_planet_records("Mercury")).to match_array([mercury])
      expect(Planet.search_planet_records("mercury")).to match_array([mercury])
    end
  end
end