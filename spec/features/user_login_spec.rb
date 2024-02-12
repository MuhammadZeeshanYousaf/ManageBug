require 'rails_helper'

RSpec.feature 'User Login' do

  let :visit_login do
    visit root_path
    click_on('Sign In')
  end

  def fill_in_credentials(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
  end

  scenario 'Manager logs in with valid credentials' do
    visit_login
    # Create a user to login with
    manager_user = create(:user, role: :manager)
    fill_in_credentials manager_user
    # Expectations: Assuming successful login redirects to the user's projects
    expect_success :manager, button_text: 'Login'
  end

  scenario 'Developer logs in with valid credentials' do
    visit_login
    # Create a user to login with
    developer_user = create(:user, role: :developer)
    fill_in_credentials developer_user
    # Expectations: Assuming successful login redirects to the user's projects
    expect_success :developer, button_text: 'Login'
  end

  scenario 'QA logs in with valid credentials' do
    visit_login
    # Create a user to login with
    qa_user = create(:user, role: :QA)
    fill_in_credentials qa_user
    # Expectations: Assuming successful login redirects to the user's projects
    expect_success :QA, button_text: 'Login'
  end

  scenario 'User sees an error with invalid credentials' do
    visit_login

    # Fill in the login form with invalid credentials
    user = create :user
    user.password = 'wrong_password'
    fill_in_credentials user
    click_on 'Login'

    # Expectations: Assuming the login fails and user stays on the login page
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('Invalid Email or password.')
  end
end
