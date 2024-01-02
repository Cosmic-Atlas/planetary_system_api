class Moon < ApplicationRecord 
  belongs_to :planet
  validates_presence_of :name, :radius_km, :rotational_period, :magnitude
  before_save :capitalize_moon_name

  scope :moons_by_planet, ->(planet_name) {Moon.joins(:planet).where(planet: {name: planet_name})}

  def capitalize_moon_name 
    self.name = name.split.map(&:capitalize).join(" ")
  end

  # def self.moons_by_planet(planet_name) #scope?
  #   Moon.joins(:planet).where(planet: {name: planet_name})
  # end

  def self.moons_by_system(system_name) #scope?
    Moon.joins(planet: :planetary_system).where(planetary_system: {name: system_name})
  end
end