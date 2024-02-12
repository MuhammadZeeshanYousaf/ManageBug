FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Alphanumeric.alphanumeric(number: 8) }
    phone_number { Faker::PhoneNumber.phone_number }

    trait :manager do
      role { :manager }
    end

    trait :developer do
      role { :developer }
    end

    trait :QA do
      role { :QA }
    end
  end
end
