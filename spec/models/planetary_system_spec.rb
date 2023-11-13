require "rails_helper"

RSpec.describe PlanetarySystem do 

  let!(:the_solar_system) {PlanetarySystem.create!(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000, created_at: Time.now)}
  let!(:tau_ceti_system) {PlanetarySystem.create!(name: "Tau Ceti", light_years_from_earth: 12, star_age: 5_800_000_000, created_at: Time.now - 1.day)}
  let!(:kepler_11_system) {PlanetarySystem.create!(name: "Kepler-11", light_years_from_earth: 2108, star_age: 3_200_000_000, created_at: Time.now - 2.days)}

  let!(:neptune) {Planet.create(name: "Neptune", planet_type: "Ice Giant", year_discovered: 1846, confirmed: true, planetary_system_id: the_solar_system.id)}
  let!(:pluto) {Planet.create(name: "Pluto", planet_type: "Dwarf", year_discovered: 1930, confirmed: false, planetary_system_id: the_solar_system.id)}
  let!(:mercury) {Planet.create(name: "Mercury", planet_type: "Terrestrial", year_discovered: 1631, confirmed: true, planetary_system_id: the_solar_system.id)}

   describe '#attributes/columns' do 
    it 'has a name, light years from earth, star age and metal rich star attributes' do
      # solar_system = PlanetarySystem.create(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)

      # expect(solar_system.name).to eq("The Solar System")
      # expect(solar_system.light_years_from_earth).to eq(0)
      # expect(solar_system.star_age).to eq(4_600_000_000)

      # solar_system = PlanetarySystem.create(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)

      expect(the_solar_system.name).to eq("The Solar System")
      expect(the_solar_system.light_years_from_earth).to eq(0)
      expect(the_solar_system.star_age).to eq(4_600_000_000)

      # expect(solar_system.metal_rich_star).to eq(true)
    end
  end

  describe 'relationship' do 
    it {should have_many :planets}
  end

  describe '::order_by_created_at' do 
    it 'orders the rows by when they were created at' do 
      # require 'pry'; binding.pry
    #   the_solar_system = PlanetarySystem.create!(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000, created_at: Time.now)
    #   tau_ceti_system = PlanetarySystem.create!(name: "Tau Ceti", light_years_from_earth: 12, star_age: 5_800_000_000, created_at: Time.now - 1.day)
    #   kepler_11_system = PlanetarySystem.create!(name: "Kepler-11", light_years_from_earth: 2108, star_age: 3_200_000_000, created_at: Time.now - 2.days)
      expect(PlanetarySystem.order_by_created_at.to_a).to eq([the_solar_system, tau_ceti_system, kepler_11_system])
    end
  end

  # before(:each) do 
  #   the_solar_system = PlanetarySystem.create(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)
  #   neptune = Planet.create(name: "Neptune", planet_type: "Ice Giant", year_discovered: 1846, confirmed: true, planetary_system_id: the_solar_system.id)
  #   pluto = Planet.create(name: "Pluto", planet_type: "Dwarf", year_discovered: 1930, confirmed: false, planetary_system_id: the_solar_system.id)
  #   mercury = Planet.create(name: "Mercury", planet_type: "Terrestrial", year_discovered: 1631, confirmed: true, planetary_system_id: the_solar_system.id)
  # end


  describe '#planets_ordered_alphabetically' do 
    it 'can order the systems planets alphabetically' do 
      # the_solar_system = PlanetarySystem.create(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)
      neptune = Planet.create(name: "Neptune", planet_type: "Ice Giant", year_discovered: 1846, confirmed: true, planetary_system_id: the_solar_system.id)
      pluto = Planet.create(name: "Pluto", planet_type: "Dwarf", year_discovered: 1930, confirmed: false, planetary_system_id: the_solar_system.id)
      mercury = Planet.create(name: "Mercury", planet_type: "Terrestrial", year_discovered: 1631, confirmed: true, planetary_system_id: the_solar_system.id)

      expect(the_solar_system.planets_ordered_alphabetically).to eq([mercury, neptune, pluto])
    end
  end

  describe '#ordered_by' do 
    it 'sorts planets by a give pattern' do 
      the_solar_system = PlanetarySystem.create(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)
      neptune = Planet.create(name: "Neptune", planet_type: "Ice Giant", year_discovered: 1846, confirmed: true, planetary_system_id: the_solar_system.id)
      pluto = Planet.create(name: "Pluto", planet_type: "Dwarf", year_discovered: 1930, confirmed: false, planetary_system_id: the_solar_system.id)
      mercury = Planet.create(name: "Mercury", planet_type: "Terrestrial", year_discovered: 1631, confirmed: true, planetary_system_id: the_solar_system.id)

      expect(the_solar_system.ordered_by(nil)).to eq([neptune, pluto, mercury])
      expect(the_solar_system.planets.all).to eq([neptune, pluto, mercury])
      expect(the_solar_system.ordered_by("alphabetical")).to eq([mercury, neptune, pluto])
      expect(the_solar_system.planets_ordered_alphabetically).to eq([mercury, neptune, pluto])
      expect(the_solar_system.ordered_by(1900)).to eq([pluto])
    end
  end

  describe '#search_records' do 
    it 'searches the records by a given keyword and returns the records that match' do 
      the_solar_system = PlanetarySystem.create!(name: "Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)
      kepler_11_system = PlanetarySystem.create!(name: "Kepler-11", light_years_from_earth: 2108, star_age: 3_200_000_000)

      expect(PlanetarySystem.search_records("Solar System")).to match_array(the_solar_system)
      expect(PlanetarySystem.search_records("Solar")).to match_array(PlanetarySystem.all)
      expect(PlanetarySystem.search_records(nil)).to match_array(PlanetarySystem.all)
    end

    it "returns all theplanets if no records is found" do 
      the_solar_system = PlanetarySystem.create!(name: "Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)
      kepler_11_system = PlanetarySystem.create!(name: "Kepler-11", light_years_from_earth: 2108, star_age: 3_200_000_000)

      expect(PlanetarySystem.search_records("Cats")).to match_array(PlanetarySystem.all)
    end

    it "searches for the records if the planet name was entered lowercase" do 
      the_solar_system = PlanetarySystem.create!(name: "Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)
      expect(PlanetarySystem.search_records("solar System")).to match_array(the_solar_system)
    end
  end

  describe "capitalization callback" do 
    it "capitalizes the planetary system name if entered lowercased" do 
      the_solar_system = PlanetarySystem.create!(name: "solar System", light_years_from_earth: 0, star_age: 4_600_000_000)

      expect(the_solar_system.name).to eq( "Solar System")
    end
  end
end