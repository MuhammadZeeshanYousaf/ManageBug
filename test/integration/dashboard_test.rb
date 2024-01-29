require "test_helper"

class DashboardTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should not get index when not sign in" do
    get root_path
    assert_template "home/index"
  end

  test "should get dashboard when signed in" do
    user = users(:user_001)
    sign_in user

    get root_path
    assert_template "home/dashboard"
  end
end
