class V1::PlanetSerializer
  include JSONAPI::Serializer 
  attributes :name, :planet_type, :year_discovered, :confirmed
end
