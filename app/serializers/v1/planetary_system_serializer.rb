class V1::PlanetarySystemSerializer
  include JSONAPI::Serializer 
  attributes :name, :light_years_from_earth, :star_age
end