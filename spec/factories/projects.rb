# frozen_string_literal: true
FactoryBot.define do
  factory :project do
    name { Faker::Company.unique.name }
    details { Faker::Lorem.paragraph }
    creator factory: :user

    # Define the image attachment using Active Storage
    after(:build) do |project|
      project.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'example.png')), filename: 'example.png', content_type: 'image/png')
    end
  end
end
