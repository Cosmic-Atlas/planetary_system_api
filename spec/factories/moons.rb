FactoryBot.define do 
  factory :moon do 
    name { Faker::Space.moon}
    radius_km { Faker::Number.number(digits: 4)}
    rotational_period { Faker::Number.within(range: 1..3)}
    magnitude { Faker::Number.between(from: -20.0, to: 20.0)}
    planet
  end
end