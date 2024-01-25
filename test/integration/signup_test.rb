require "test_helper"

class SignupTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = User.new(name: "Touseef Ali", email: "touseef@visnext.com", phone_number: "090078601", role: "manager", password: "password", password_confirmation: "password")
  end

  test "should get to sign up page" do
    get new_user_registration_path(role: "manager")
    assert_response :success
  end

  test "User should get created" do
    get new_user_registration_path(role: "manager")
    assert_difference "User.count", 1 do
      post user_registration_path, params: { user: { name: "Touseef Ali", email: "touseef@visnext.com", phone_number: "090078601", role: "manager", password: "password", password_confirmation: "password" }}
    end
    follow_redirect!
    assert_template "home/dashboard"
  end

  test "False user shoudld not get created" do
    get new_user_registration_path(role: "manager")
    assert_no_difference "User.count", 1 do
      post user_registration_path, params: { user: { name: "Touseef Ali", email: "", phone_number: "090078601", role: "manager", password: "password", password_confirmation: "" }}
    end
  end
end
