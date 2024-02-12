module AuthenticationHelper
  def expect_success(role, button_text: 'Login')
    role = role.to_s
    raise ArgumentError, "role param must be #{User.roles.keys.join(' or ')}" unless User.roles.keys.include?(role)

    click_link_or_button button_text
    expect(page).to have_http_status(:success)
    expect(page).to have_current_path(projects_path)
    expect(page).to have_content('Projects')
    if role.downcase.eql?'manager'
      expect(page).to have_selector(:link_or_button, 'Add New Project')
    else
      expect(page).not_to have_selector(:link_or_button, 'Add New Project')
    end
  end

  # Login helpers
  def visit_login
    visit root_path
    click_on('Sign In')
  end

  def fill_in_credentials(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
  end

  def expect_successful_login(user_role)
    user_role = user_role.to_s
    raise ArgumentError, "role param must be #{User.roles.keys.join(' or ')}" unless User.roles.keys.include?(user_role)

    visit_login
    # Create a user to login with
    user = create(:user, user_role)
    fill_in_credentials user
    # Expectations: Assuming successful login redirects to the user's projects
    expect_success user_role, button_text: 'Login'
    user
  end

end
