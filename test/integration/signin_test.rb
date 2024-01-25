require "test_helper"

class SigninTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  test "should get to sign in path" do
    get new_user_session_path
    assert_response :success
  end

  test "should sign in" do
    get new_user_session_path
    assert_response :success

    user = users(:user_001)
    sign_in user
    get root_path
    assert_template "home/dashboard"
  end
end
