require "rails_helper"

RSpec.describe PlanetarySystem do 
   describe '#attributes/columns' do 
    it 'has a name, light years from earth, star age and metal rich star attributes' do
      solar_system = PlanetarySystem.create(name: "The Solar System", light_years_from_earth: 0, star_age: 4_600_000_000)

      expect(solar_system.name).to eq("The Solar System")
      expect(solar_system.light_years_from_earth).to eq(0)
      expect(solar_system.star_age).to eq(4_600_000_000)
      # expect(solar_system.metal_rich_star).to eq(true)
    end
  end

  describe 'relationship' do 
    it {should have_many :planets}
  end
end