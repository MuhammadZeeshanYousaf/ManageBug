require "test_helper"
include ActionDispatch::TestProcess

class CreateBugTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user_001)
    @user2 = users(:user_002)
    @user3 = users(:user_003)
    @file = fixture_file_upload("test/fixtures/files/broom.png", "image/png")
    @project = Project.new(name: "New Project", details: "These are short details of project", image: @file, creator_id: @user.id)
    @project.save
  end

  test "should get the project show page" do
    sign_in @user3 # signing the QA user
    get project_path(@project)
    assert_response :success
  end

  test "should create bug with only QA user" do
    sign_in @user3 # signing the QA user
    get project_path(@project)
    assert_response :success
    new_bug = { title: "Test bug 1", description: "Test description of bug", deadline: 10.days.from_now,
                bug_type: 0, status: 0, creator_id: @user3.id, project_id: @project.id, user_id: @user2.id, image: @file }
    assert_difference "Bug.count", 1 do
      post bugs_path, params: { bug: new_bug }
    end
    assert_redirected_to project_path(@project)
    follow_redirect!
    assert_template "projects/show"
  end

  test "should not create bug except QA user" do
    sign_in @user2
    get project_path(@project)
    assert_response :success
    new_bug = { title: "Test bug", description: "Test description of bug", deadline: 10.days.from_now,
                bug_type: 0, status: 0, creator_id: @user2.id, project_id: @project.id, user_id: @user2.id, image: @file }
    assert_no_difference "Bug.count" do
      post bugs_path, params: { bug: new_bug }
    end
    assert_template "projects/show"
    assert_not flash.empty?
  end
end
