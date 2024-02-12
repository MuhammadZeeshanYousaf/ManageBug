require 'support/authentication_helpers'

RSpec.feature 'User Login' do

  scenario 'Manager logs in with valid credentials' do
    expect_successful_login :manager
  end

  scenario 'Developer logs in with valid credentials' do
    expect_successful_login :developer
  end

  scenario 'QA logs in with valid credentials' do
    expect_successful_login :QA
  end

  scenario 'User sees an error with invalid credentials' do
    visit_login

    # Fill in the login form with invalid credentials
    user = create :user, :manager
    user.password = 'wrong_password'
    fill_in_credentials user
    click_on 'Login'

    # Expectations: Assuming the login fails and user stays on the login page
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('Invalid Email or password.')
  end
end
