class V1::MoonSerializer 
  include JSONAPI::Serializer 
  attributes :name, :radius_km, :rotational_period, :magnitude
end