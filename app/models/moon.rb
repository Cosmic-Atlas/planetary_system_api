class Moon < ApplicationRecord 
  belongs_to :planet
  validates_presence_of :name, :radius_km, :rotational_period, :magnitude
end