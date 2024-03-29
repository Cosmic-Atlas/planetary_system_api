require "rails_helper"

RSpec.describe Moon do 
  let!(:the_solar_system) {PlanetarySystem.create!(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000, created_at: Time.now)}

  let!(:earth) {Planet.create(name: "Earth", planet_type: "Terrestrial", year_discovered: 0, confirmed: true, planetary_system_id: the_solar_system.id)}
  let!(:luna) {Moon.create!(name: "Luna", radius_km: 1737, rotational_period: 27.0, magnitude: -12.74, planet_id: earth.id)}

  let!(:jupiter) {Planet.create!(name: "Jupiter", planet_type: "Gas Giant", year_discovered: 1610, confirmed: true, planetary_system_id: the_solar_system.id)}
  let!(:europa) {Moon.create!(name: "Europa", radius_km: 1561, rotational_period: 3.0, magnitude: 5.29, planet_id: jupiter.id)} #rotational period 3.5
  let!(:io) {Moon.create!(name: "Io", radius_km: 1821.3, rotational_period: 1.0, magnitude: 5.02, planet_id: jupiter.id)} #rotational period 1.7
  let!(:ganymede) {Moon.create!(name: "Ganymede", radius_km: 2631, rotational_period: 7.0, magnitude: 4.61, planet_id: jupiter.id)}

  let!(:mercury) {Planet.create!(name: "Mercury", planet_type: "Terrestrial", year_discovered: 1631, confirmed: true, planetary_system_id: the_solar_system.id)}
  let!(:venus) {Planet.create!(name: "Venus", planet_type: "Terrestrial", year_discovered: 1610, confirmed: true, planetary_system_id: the_solar_system.id)}

  describe "attribues" do 
    it "has attributes" do 
      expect(luna.name).to eq("Luna")
      expect(luna.radius_km).to eq(1737)
      expect(luna.rotational_period).to eq(27.0)
      expect(luna.magnitude).to eq(-12.74)
    end
  end

  describe "associations" do 
    it {should belong_to :planet}
  end

  describe "validations" do 
    it "should capitalize the moon name if it was created lowecase" do 
      lowercase_moon = Moon.create!(name: "moon", radius_km: 1700, rotational_period: 10.0, magnitude: 10.00, planet_id: earth.id)

      expect(lowercase_moon.name).to eq("Moon")
    end
  end

  describe "moons_by_planet" do 
    it "gets all the moons by a specific planet" do 
      expect(Moon.moons_by_planet("Jupiter")).to match_array([europa, io, ganymede])
      expect(Moon.moons_by_planet("Earth")).to match_array([luna])
    end

    it "returns an empty array for planets without moons" do 
      expect(Moon.moons_by_planet("Mercury")).to match_array([])
      expect(Moon.moons_by_planet("Venus")).to match_array([])
    end

    it "returns an empty array for a planet name not in the database" do 
      expect(Moon.moons_by_planet("No Planet")).to match_array([])
    end

    it "returns an empty array when an empty string is passed" do 
      expect(Moon.moons_by_planet("")).to match_array([])
    end
  end

  describe "moons_by_system" do 
    it "gets all moons by a specific solar system" do 
      expect(Moon.moons_by_system("The Solar System")).to match_array([luna, europa, io, ganymede])
    end
  end

  describe "search_moon_records" do 
    it "can search for and return a moon by searching its name" do 
      expect(Moon.search_moon_records("Luna")).to match_array([luna])
      expect(Moon.search_moon_records("Lunarrr")).to match_array(Moon.all)
      expect(Moon.search_moon_records(nil)).to match_array(Moon.all)
      expect(Moon.search_moon_records("Europa")).to match_array([europa])
      expect(Moon.search_moon_records("europa")).to match_array([europa])
    end
  end
end