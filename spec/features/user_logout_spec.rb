require 'support/authentication_helpers'

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

  context 'Manger' do
    scenario 'logs out successfully' do
      # Verify that the user is logged in
      manager_user = expect_successful_login :manager
      # Perform logout
      expect_successful_logout manager_user
    end

    scenario 'attempts to access restricted page after logout' do
      manager_user = expect_successful_login :manager

      # Perform logout
      expect_successful_logout manager_user

      expect_no_projects_access
    end
  end

  context 'Developer' do
    scenario 'logs out successfully' do
      # Perform Login and then logout
      expect_successful_logout expect_successful_login :developer
    end

    scenario 'attempts to access restricted page after logout' do
      # Perform Login and then logout
      expect_successful_logout expect_successful_login :developer
      expect_no_projects_access
    end
  end

  context 'QA' do
    scenario 'logs out successfully' do
      # Perform Login and then logout
      expect_successful_logout expect_successful_login :QA
    end

    scenario 'attempts to access restricted page after logout' do
      # Perform Login and then logout
      expect_successful_logout expect_successful_login :QA
      expect_no_projects_access
    end
  end


end

