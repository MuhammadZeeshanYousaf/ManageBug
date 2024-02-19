# frozen_string_literal: true

FactoryBot.define do
  factory :bug do
    project
    association :creator, factory: [:user, :manager]
    association :developer, factory: [:user, :developer]
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    deadline { Faker::Time.forward(days: 10) }
    screenshot { [
      Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/images/example.png")),
      Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/images/example.gif")),
    ].sample }
    bug_type { %w[feature bug].sample }
    status { %w[pending started completed resolved].sample }
  end
end
