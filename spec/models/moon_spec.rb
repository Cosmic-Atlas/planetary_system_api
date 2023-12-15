require "rails_helper"

RSpec.describe Moon do 
  let!(:the_solar_system) {PlanetarySystem.create!(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000, created_at: Time.now)}
  let!(:earth) {Planet.create(name: "Earth", planet_type: "Terrestrial", year_discovered: 0, confirmed: true, planetary_system_id: the_solar_system.id)}
  let!(:luna) {Moon.create!(name: "Luna", radius_km: 1737, rotational_period: 27, magnitude: -12.74, planet_id: earth.id)}

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
end