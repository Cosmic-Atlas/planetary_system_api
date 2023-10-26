class Planet < ApplicationRecord 
  belongs_to :planetary_system
  validates_presence_of :name, :planet_type, :year_discovered
  validates :confirmed, inclusion: [true, false]

  before_save :capitalize_planet_name

  scope :confirmed_planets, -> {Planet.where(confirmed: true)}
  scope :unconfirmed_planets, -> {Planet.where(confirmed: false)}
  # scope :filter_planet_type, ->(input) {where(planet_type: input)}
  scope :filter_planet_type, ->(input) {where("planet_type ILIKE ?", "%#{input}%")}

  def capitalize_planet_name 
    # self.name = name.capitalize
    self.name = name.split.map(&:capitalize).join(" ")
  end

  def self.search_planet_records(search)
    if search 
      name_search_key = Planet.find_by(name: search.capitalize)
      name_search_key ? self.where(id: name_search_key) : Planet.all
    else 
      Planet.all
    end
  end

  # def self.filter_planet_type(input)
  #   where(planet_type: input)
  # end
end