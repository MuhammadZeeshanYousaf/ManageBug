require 'rails_helper'

RSpec.describe User, type: :feature do

  describe "Controller Requests" do

    context 'Register and Login of Manager' do
      let :manager_data do
        { role: :manager, name: 'John Doe', email: 'john.doe@email.com', password: '123456', phone_number: '123-456-7890' }
      end
      let(:user) { described_class.create(manager_data) }

      let :visit_signup do
        visit '/'
        click_link('Manager')
        expect(current_url).to include('/users/sign_up?role=manager')
      end

      it 'Signs up with test data' do
        visit_signup
        expect(page).to have_content('Sign up')

        fill_in 'floatingName', with: manager_data[:name], exact: true
        fill_in 'floatingPhoneNumber', with: manager_data[:phone_number], exact: true
        fill_in 'floatingEmail', with: manager_data[:email], exact: true
        fill_in 'floatingPassword', with: manager_data[:password], exact: true
        fill_in 'floatingConfirmPassword', with: manager_data[:password], exact: true

        click_button 'Sign up'
        expect(page).to have_http_status(:success)
        expect(current_path).to have_content('/projects')
        expect(page).to have_button('Add New Project')
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

        fill_in('Email', with: manager_data[:email])
        fill_in('Password', with: manager_data[:password])
        click_button('Login')

        expect(page).to have_http_status(:success)
        expect(current_path).to include('/projects')
        expect(page).to have_button('Add New Project')
      end
    end
  end
end
