require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Touseef Ali", email: "touseef@visnext.com", phone_number: "090078601", role: "manager", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "email should be valid" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "name should be less than 30 characters" do
    @user.name = "a" * 31
    assert_not @user.valid?
  end

  test "password should be present" do
    @user.password = " "
    assert_not @user.valid?
  end

  test "password confirmation should be present" do
    @user.password_confirmation = " "
    assert_not @user.valid?
  end

  test "role should be present" do
    @user.role = " "
    assert_not @user.valid?
  end

end
