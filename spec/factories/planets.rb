FactoryBot.define do 
  factory :planet do 
    name { Faker::Space.planet }
    planet_type { Faker::Lorem.word }
    year_discovered { Faker::Number.number(digits: 4)}
    confirmed { Faker::Boolean.boolean }
    planetary_system
  end
end