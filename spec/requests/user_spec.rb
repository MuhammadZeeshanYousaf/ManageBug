require 'rails_helper'

RSpec.describe User, type: :feature do

  describe "Controller Requests" do

    context 'Register and Login of Manager' do
      let(:user) { described_class.create(role: :manager, name: 'John Doe', email: 'john.doe@email.com', password: '123456', phone_number: '123-456-7890') }

      let :visit_signup do
        visit '/'
        click_link('Manager')
        expect(current_url).to include('/users/sign_up?role=manager')
      end

      it 'Signs up with test data' do
        visit_signup
        expect(page).to have_content('Sign up')
      end

      let :visit_sign_in do
        visit '/'
        expect(page).to have_link('Sign in')
        click_link('Sign in')
        expect(current_url).to include('/users/sign_in')
      end

      it 'logs in with test credentials' do
        expect(user).to be_valid

        visit_sign_in

        fill_in('Email', with: 'john.doe@email.com')
        fill_in('Password', with: '123456')
        click_button('Login')

        expect(page).to have_http_status(:success)
        expect(current_path).to include('/projects')
      end
    end
  end
end
