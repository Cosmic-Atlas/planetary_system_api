class PlanetarySystem < ApplicationRecord
  has_many :planets, dependent: :destroy

  validates_presence_of :name, :light_years_from_earth, :star_age
  # validates :metal_rich_star, inclusion: [true, false]

  before_save :capitalize_planetary_system_name

  scope :order_by_created_at, -> {self.order(created_at: :DESC)}

  def planets_ordered_alphabetically 
    self.planets.order(:name)
  end

  def capitalize_planetary_system_name
    self.name = name.split.map(&:capitalize).join(" ")
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

  # def self.search_records(search)
  #   if search
  #     name_search_key = PlanetarySystem.find_by(name: search)
  #     if name_search_key 
  #       self.where(id: name_search_key)
  #     else
  #       PlanetarySystem.all
  #     end
  #   else 
  #     PlanetarySystem.all
  #   end
  # end

  def self.search_records(search)
    search.nil? ? name_input = nil : name_input = search.split.map(&:capitalize).join(" ")
 
    if search 
      name_search_key = PlanetarySystem.find_by(name: name_input)
      name_search_key ? self.where(id: name_search_key) : PlanetarySystem.all
    else 
      PlanetarySystem.all
    end
  end
end