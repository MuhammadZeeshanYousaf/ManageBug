require 'rails_helper'

RSpec.describe "Projects", type: :request do
  # memoized block will be evaluated when 'user' got assigned in any context
  context 'when user is manager' do
    let(:manager) { create :user }
    let(:project) { create :project, creator: manager }
    before(:each) { sign_in manager }

    describe "GET /index" do
      it { expect_index_response }
    end

    describe 'POST /projects' do
      it 'creates project and verify count change' do
        project_attrs = attributes_for :project, creator: manager
        project_attrs[:image] = fixture_file_upload('spec/fixtures/images/example.png', 'image/png')

        expect { post projects_path, params: { project: project_attrs } }.to change(Project, :count).by(1)
        expect(response).to redirect_to(projects_path)
      end
    end

    describe "GET projects/:id (manager)" do
      it "returns http success and renders template" do
        get project_path(project)

        expect(assigns(:project)).to eq(project)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
    end
  end

  context 'when user is developer' do
    let(:developer) { create :user, :developer }
    before(:each) { sign_in developer }

    describe "GET /index" do
      it { expect_index_response }
    end

    describe "GET projects/:id (developer)" do
      let(:project) { create :project }

      it 'assigns a project and verify' do
        create(:project_user, project:, user: developer)
        expect_show_response
      end

      it 'does not assign and verify inaccessibility' do
        expect { get project_path(project) }.to raise_error(CanCan::AccessDenied)
      end
    end

    describe 'POST /projects' do
      it 'returns http status unauthorized' do
        project_attrs = attributes_for :project
        project_attrs[:image] = fixture_file_upload('spec/fixtures/images/example.png', 'image/png')

        expect { post projects_path, params: { project: project_attrs } }.to raise_error(CanCan::AccessDenied)
      end
    end
  end


  private

    def expect_index_response
      get projects_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    def expect_show_response
      get project_path(project)

      expect(assigns(:project)).to eq(project)
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

end
