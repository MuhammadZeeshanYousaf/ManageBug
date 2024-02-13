# frozen_string_literal: true

FactoryBot.define do
  factory :bug do
    project
    user
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    deadline { Faker::Time.forward(days: 10) }
    screenshot { Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/images/example.png")) }
    bug_type { %w[feature bug].sample }
    status { %w[open in_progress resolved closed].sample }
  end
end
