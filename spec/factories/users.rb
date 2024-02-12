FactoryBot.define do
  factory :user do
    transient do
      user_role  { 'manager' }
    end
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Alphanumeric.alphanumeric(number: 8) }
    phone_number { Faker::PhoneNumber.phone_number }
    role { user_role }
  end
end
