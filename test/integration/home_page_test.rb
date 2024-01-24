require "test_helper"

class HomePageTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get home page" do
    get root_path
    assert_response :success
    assert_select "div.custom-card"
    assert_select "div.page-left-image"
    assert_select "a[href=?]", new_user_registration_path(role: "manager")
    assert_select "a[href=?]", new_user_registration_path(role: "QA")
    assert_select "a[href=?]", new_user_registration_path(role: "developer")
  end

end
