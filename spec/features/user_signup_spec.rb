require 'support/authentication_helper'

RSpec.describe 'User Sign up' do

  context 'for manager' do
    it 'successfully creates account for manager' do
      visit_signup :manager
      manager_user = build(:user, :manager)
      expect(manager_user.role).to eq('manager')
      fill_in_details manager_user
      expect_success :manager, button_text: 'Sign Up'
    end
  end

  context 'for developer' do
    it 'successfully creates account for developer' do
      visit_signup :developer
      developer_user = build(:user, :developer)
      expect(developer_user.role).to eq('developer')
      fill_in_details developer_user
      expect_success :developer, button_text: 'Sign Up'
    end
  end

  context 'for QA' do
    it 'successfully creates account for QA' do
      visit_signup :QA
      qa_user = build(:user, :QA)
      expect(qa_user.role).to eq('QA')
      fill_in_details qa_user
      expect_success :QA, button_text: 'Sign Up'
    end
  end


  private

    def visit_signup(role)
      role = role.to_s
      raise ArgumentError, "role param must be #{User.roles.keys.join(' or ')}" unless User.roles.keys.include?(role)
      visit root_path
      find("a[href='#{new_user_registration_path(role: role)}']", text: role.camelize).click
      expect(current_url).to include(new_user_registration_path(role: role))
      expect(page).to have_content('Sign Up')
    end

    def fill_in_details(user)
      raise ArgumentError, 'user param must be an object of User class' unless user.is_a? User
      fill_in 'user[name]', with: user.name, exact: true
      fill_in 'user[phone_number]', with: user.phone_number, exact: true
      fill_in 'user[email]', with: user.email, exact: true
      fill_in 'user[password]', with: user.password, exact: true
      fill_in 'user[password_confirmation]', with: user.password, exact: true
    end

end
