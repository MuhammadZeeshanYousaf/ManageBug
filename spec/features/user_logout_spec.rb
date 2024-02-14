require 'support/authentication_helper'

RSpec.feature 'User Logout', type: :feature do

  def expect_successful_logout(user)
    # Find a <span> element with the user name as text using XPath selector
    find(:xpath, "//span[contains(text(), '#{user.name}')]").click

    click_on 'Logout'

    # Expectations: Assuming successful logout redirects to the home page
    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Sign In')
  end

  def expect_no_projects_access
    # Attempt to access a restricted page (customize based on your application)
    visit projects_path

    # Expectations: Assuming the user is redirected to the login page after logout
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  def login_user(role)
    role = role.to_s
    raise ArgumentError, "role param must be #{User.roles.keys.join(' or ')}" unless User.roles.keys.include?(role)

    user = create :user, role
    sign_in user
    visit projects_path
    user
  end

  context 'Manager' do
    let!(:logged_in_manager) { login_user :manager }

    scenario 'logs out successfully' do
      # Perform logout
      expect_successful_logout logged_in_manager
    end

    scenario 'attempts to access restricted page after logout' do
      # Perform logout
      sign_out logged_in_manager

      expect_no_projects_access
    end
  end

  context 'Developer' do
    let!(:logged_in_developer) { login_user :developer }

    scenario 'logs out successfully' do
      expect_successful_logout logged_in_developer
    end

    scenario 'attempts to access restricted page after logout' do
      sign_out logged_in_developer
      expect_no_projects_access
    end
  end

  context 'QA' do
    let!(:logged_in_qa) { login_user :QA }

    scenario 'logs out successfully' do
      expect_successful_logout logged_in_qa
    end

    scenario 'attempts to access restricted page after logout' do
      sign_out logged_in_qa
      expect_no_projects_access
    end
  end


end

