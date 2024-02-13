require 'rails_helper'

RSpec.describe Bug, type: :model do
  let(:manager) { create :user, :manager }
  let(:project) { create :project, creator: manager }
  let(:creator) { create :user, :QA }
  let(:developer) { create :user, :developer }

  it 'validates uniqueness of title within the scope of a project' do
    # Create a bug with a specific title
    existing_bug = create(:bug, project:, creator:, developer:, title: 'Duplicate Title')

    # Attempt to create another bug with the same title within the same project
    duplicate_title_bug = build(:bug, project:, creator:, developer:, title: 'Duplicate Title')

    # Expect the validation error on the title attribute
    expect { duplicate_title_bug.save! }.to raise_error(ActiveRecord::RecordInvalid, /Title has already been taken/)
  end


end
