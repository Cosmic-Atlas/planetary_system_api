class PlanetarySystem < ApplicationRecord
  has_many :planets, dependent: :destroy
  validates :name, presence: true
  validates :light_years_from_earth, presence: true
  validates :star_age, presence: true
  # validates :metal_rich_star, inclusion: [true, false]
end