# frozen_string_literal: true

# spec/models/project_spec.rb

require 'rails_helper'

RSpec.describe Project, type: :model do

  describe 'project bugs' do
    let(:manager) { create :user, :manager}
    let(:project) { create :project, creator: manager }
    let(:creator) { create :user, :QA }
    let(:developer) { create :user, :developer }
    # Create multiple bugs associated with the project
    let(:bug1) { create(:bug, project:, creator:, developer:) }
    let(:bug2) { create(:bug, project:, creator:, developer:) }
    let(:bug3) { create(:bug, project:, creator:, developer:) }

    context 'project' do
      it 'can have multiple bugs' do
        expect(project.bugs).to include(bug1, bug2, bug3)
      end
    end

    context 'manager' do
      it 'can create project' do
        expect(project.creator).to eq(manager)
      end
    end

    context 'QA' do
      it 'can create multiple bugs' do
        expect(creator).to be_QA
        expect(bug1.creator).to eq(creator)
        expect(bug2.creator).to eq(creator)
        expect(bug2.creator).to eq(creator)
      end

      it 'can assign bugs to developer' do
        # Reload the project to make sure the association is updated
        project.reload

        # Check if the bugs are assigned to the developer
        expect(developer.bugs).to include(bug1, bug2, bug3)
      end
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
