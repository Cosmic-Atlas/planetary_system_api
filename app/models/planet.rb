class Planet < ApplicationRecord 
  belongs_to :planetary_system
  validates_presence_of :name, :planet_type, :year_discovered
  validates :confirmed, inclusion: [true, false]
  before_save :capitalize_planet_name

  scope :only_true, -> {Planet.where(confirmed: true)}

  def capitalize_planet_name 
    self.name = name.capitalize
  end
end