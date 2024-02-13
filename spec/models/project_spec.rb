# frozen_string_literal: true

# spec/models/project_spec.rb

require 'rails_helper'

RSpec.describe Project, type: :model do

  describe 'project bugs' do
    it 'can have multiple bugs' do
      creator = create :user, :manager
      project = create(:project, creator:)

      # Create multiple bugs associated with the project
      assignee = create :user, :developer
      bug1 = create(:bug, project:, user: assignee)
      bug2 = create(:bug, project:, user: assignee)
      bug3 = create(:bug, project:, user: assignee)

      # Reload the project to make sure the association is updated
      project.reload

      # Check if the bugs are associated with the project
      expect(project.bugs).to include(bug1, bug2, bug3)
    end
  end

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
