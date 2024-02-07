require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it 'returns http status success and renders index template' do
      get '/'
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:success)
      expect(response).to be_successful
    end
  end
end
