require "rails_helper"

RSpec.describe Moon do 
  let!(:the_solar_system) {PlanetarySystem.create!(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000, created_at: Time.now)}
  let!(:earth) {Planet.create(name: "Earth", planet_type: "Terrestrial", year_discovered: 0, confirmed: true, planetary_system_id: the_solar_system.id)}
  let!(:luna) {Moon.create!(name: "Luna", radius_km: 1737, rotational_period: 27, magnitude: -12.74, planet_id: earth.id)}

  let!(:jupiter) {Planet.create!(name: "Jupiter", planet_type: "Gas Giant", year_discovered: 1610, confirmed: true, planetary_system_id: the_solar_system.id)}
  let!(:europa) {Moon.create!(name: "Europa", radius_km: 1561, rotational_period: 3, magnitude: 5.29, planet_id: jupiter.id)} #rotational period 3.5
  let!(:io) {Moon.create!(name: "Io", radius_km: 1821.3, rotational_period: 1, magnitude: 5.02, planet_id: jupiter.id)} #rotational period 1.7
  let!(:ganymede) {Moon.create!(name: "Ganymede", radius_km: 2631, rotational_period: 7, magnitude: 4.61, planet_id: jupiter.id)}
  #change rotational period to float in db


  describe "attribues" do 
    it "has attributes" do 
      expect(luna.name).to eq("Luna")
      expect(luna.radius_km).to eq(1737)
      expect(luna.rotational_period).to eq(27)
      expect(luna.magnitude).to eq(-12.74)
    end
  end

  describe "associations" do 
    it {should belong_to :planet}
  end

  describe "validations" do 
    it "should capitalize the moon name if it was created lowecase" do 
      lowercase_moon = Moon.create!(name: "moon", radius_km: 1700, rotational_period: 10, magnitude: 10.00, planet_id: earth.id)

      expect(lowercase_moon.name).to eq("Moon")
    end
  end

  describe "moons_by_planet" do 
    it "gets all the moons by a specific planet" do 
      expect(Moon.moons_by_planet("Jupiter")).to eq([europa, io, ganymede])
    end
  end
end