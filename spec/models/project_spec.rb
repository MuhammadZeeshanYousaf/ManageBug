# frozen_string_literal: true

# spec/models/project_spec.rb

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should have_many(:project_users).dependent(:destroy) }
    it { should have_many(:users).through(:project_users) }
    it { should have_one_attached(:image) }
    it { should have_many(:bugs) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_presence_of(:image) }
    it { should validate_presence_of(:creator_id) }
  end
  
end
