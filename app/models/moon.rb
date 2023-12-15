class Moon < ApplicationRecord 
  belongs_to :planet
  validates_presence_of :name, :radius_km, :rotational_period, :magnitude
  before_save :capitalize_moon_name

  def capitalize_moon_name 
    self.name = name.split.map(&:capitalize).join(" ")
  end

end