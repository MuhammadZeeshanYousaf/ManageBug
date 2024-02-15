require 'rails_helper'

RSpec.describe "Bugs", type: :request do

  context 'when user is QA' do
    let(:qa) { create :user, :QA }
    before(:each) { sign_in qa }
    let(:developer) { create :user, :developer }
    let(:project) { create :project } # created by arbitrary manager

    describe 'POST /projects/:project_id/bugs' do
      it 'creates a bug' do
        bug_attrs = attributes_for(:bug, creator: qa)
        bug_attrs[:screenshot] = fixture_file_upload('spec/fixtures/images/example.png', 'image/png')
        bug_attrs[:user_id] = developer.id  # todo - change this to developer_id if foreign key changes

        expect { post project_bugs_path(project), params: { bug: bug_attrs } }.to change(Bug, :count).by(1)
        expect(response).to redirect_to(project_path(project))
      end
    end

  end

  context 'when user is developer' do
    let(:developer) { create :user, :developer }
    before(:each) { sign_in developer }
    let(:qa) { create :user, :QA }
    let(:project) { create :project } # created by arbitrary manager

    describe 'POST /projects/:project_id/bugs' do
      it 'does not allow creating bug' do
        bug_attrs = attributes_for :bug
        bug_attrs[:screenshot] = fixture_file_upload('spec/fixtures/images/example.png', 'image/png')
        bug_attrs[:user_id] = developer.id  # todo - change this to developer_id if foreign key changes

        post project_bugs_path(project), params: { bug: bug_attrs }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

end
