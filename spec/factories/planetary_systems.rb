FactoryBot.define do 
  factory :planetary_system do 
    name { Faker::Space.star }
    light_years_from_earth { Faker::Number.between(from: 1, to: 10)}
    star_age { Faker::Number.number(digits: 8)}
  end
end