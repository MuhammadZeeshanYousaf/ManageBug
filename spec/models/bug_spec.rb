require 'rails_helper'

RSpec.describe Bug, type: :model do
  let(:manager) { create :user, :manager }
  let(:project) { create :project, creator: manager }
  let(:creator) { create :user, :QA }
  let(:developer) { create :user, :developer }

  it 'is valid when associated with a developer' do
    bug = build(:bug, developer:, project:)
    expect(bug).to be_valid
  end

  it 'is invalid without an associated developer' do
    bug = build(:bug, developer: nil, project:)
    expect(bug).to be_invalid
    expect(bug.errors[:developer]).to include("can't be blank")
  end

  it 'is invalid when associated with QA' do
    bug = build :bug, developer: creator
    expect(bug).to be_invalid
  end

  it 'is invalid when associated with manager' do
    bug = build :bug, developer: manager
    expect(bug).to be_invalid
  end

  subject(:bug) { build(:bug, developer:, creator:, project:) }

  # Associations
  it { should belong_to(:project) }
  # QA can create bugs
  it { should belong_to(:creator).class_name('User') }
  # A bug belongs to a developer who will solve it.
  it { should belong_to(:developer).class_name('User') }

  context 'Enums of status and bug_type' do
    it { should define_enum_for(:status).with_values(pending: 0, started: 1, completed: 2, resolved: 3) }
    it { should define_enum_for(:bug_type).with_values(bug: 0, feature: 1) }
    # Status should be values (pending, started, completed) for features and (pending, started, resolved) for bugs.
    xit 'validates status based on bug_type' do
      bug.feature!  # when bug_type is 'feature'
      expect(bug).to validate_inclusion_of(:status).in_array(%w[pending started completed])

      bug.bug!  # when bug_type is 'bug'
      expect(bug).to validate_inclusion_of(:status).in_array(%w[pending started resolved])
    end
  end

  context 'Validations' do
    it { should validate_presence_of(:developer) }
    it { should validate_presence_of(:title) }
    # Title of a bug should be unique within the scope of a project.
    it { should validate_uniqueness_of(:title).scoped_to(:project_id) }
    # A bug must belongs to a project.
    it { should validate_presence_of(:project_id) }
    it { should validate_presence_of(:deadline) }
    it 'validates that deadline cannot be in the past' do
      bug.deadline = Date.yesterday
      expect(bug).not_to be_valid
      expect(bug.errors[:deadline]).to include('cannot be in the past')

      bug.deadline = Date.tomorrow
      expect(bug).to be_valid
    end
  end

  context 'title, status, and bug_type are required for bug creation' do
    it 'is invalid without title' do
      bug.title = nil
      expect(bug).to be_invalid
      expect(bug.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without status' do
      bug.status = nil
      expect(bug).to be_invalid
      expect(bug.errors[:status]).to include("can't be blank")
    end

    it 'is invalid without type' do
      bug.bug_type = nil
      expect(bug).to be_invalid
      expect(bug.errors[:bug_type]).to include("can't be blank")
    end

    it 'is valid with required attributes' do
      expect(bug).to be_valid
    end
  end

  context 'Description and Screenshot are optional' do
    it 'is valid without description and screenshot' do
      bug.description = nil
      bug.screenshot = nil
      expect(bug).to be_valid
    end
  end

  it 'validates assignee is developer' do
    expect(bug).to allow_value(bug.developer).for(:developer)
    expect(bug).not_to allow_value(build(:user, :manager)).for(:developer)
  end

end
