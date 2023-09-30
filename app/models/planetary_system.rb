class PlanetarySystem < ApplicationRecord
  has_many :planets, dependent: :destroy
  validates :name, presence: true
  validates :light_years_from_earth, presence: true
  validates :star_age, presence: true
  # validates :metal_rich_star, inclusion: [true, false]

  scope :order_by_created_at, -> {self.order(created_at: :DESC)}

  def planets_ordered_alphabetically 
    self.planets.order(:name)
  end

  def ordered_by(order_pattern)
    if order_pattern.nil?
      self.planets.all
    elsif order_pattern == "alphabetical"
      self.planets_ordered_alphabetically
    elsif order_pattern.to_i.class == Integer 
      self.planets.where("year_discovered > #{order_pattern}")
    end
  end
end