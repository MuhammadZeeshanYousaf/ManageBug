require "test_helper"
include ActionDispatch::TestProcess

class CreateProjectTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user_001)
    @user2 = users(:user_002)
    @user3 = users(:user_003)
    @file = fixture_file_upload("test/fixtures/files/broom.png", "image/png")
  end

  test "should get to projects path" do
    sign_in @user
    get projects_path
    assert_response :success
  end

  test "should create project with manager user" do
    sign_in @user
    get projects_path
    my_project = {name: "Test project", details: "Test project details", image: @file, creator_id: @user.id}
    assert_difference "Project.count", 1 do
      post projects_path, params: { project: my_project }
    end
    assert_redirected_to projects_path
    follow_redirect!
    assert_template "projects/index"
  end

  test "should not be created except manager user" do
    sign_in @user2
    get projects_path
    my_project = {name: "Test project", details: "Test project details", image: @file, creator_id: @user.id}
    assert_no_difference "Project.count" do
      post projects_path, params: { project: my_project }
    end
    assert_template "projects/index"
    assert_not flash.empty?
  end
end
