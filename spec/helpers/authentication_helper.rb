module AuthenticationHelper
  def expect_success(role, button_text: 'Login')
    role = role.to_s
    raise ArgumentError, "role param must be #{User.roles.keys.join(' or ')}" unless User.roles.keys.include?(role)
    click_on button_text
    expect(page).to have_http_status(:success)
    expect(page).to have_current_path('/projects')
    expect(page).to have_content('Projects')
    if role.downcase.eql?'manager'
      expect(page).to have_selector(:link_or_button, 'Add New Project')
    else
      expect(page).not_to have_selector(:link_or_button, 'Add New Project')
    end
  end

end
