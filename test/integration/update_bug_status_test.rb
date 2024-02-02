require "test_helper"
include ActionDispatch::TestProcess

class UpdateBugStatusTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user_001)
    @user2 = users(:user_002)
    @user3 = users(:user_003)
    @file = fixture_file_upload("test/fixtures/files/broom.png", "image/png")
    @project = Project.new(name: "New Project", details: "These are short details of project", image: @file, creator_id: @user.id)
    @project.save
    @bug = Bug.create!(title: "Bug 1", description: "Test description", deadline: 10.days.from_now,
                       bug_type: 0, status: 0, creator_id: @user3.id, project_id: @project.id, user_id: @user2.id, image: @file)
  end

  test "should update bug status" do
    sign_in @user3
    get project_path(@project)
    put bug_path(@bug, project_id: @project.id, status: "closed")
    assert_redirected_to project_path(@project)
    follow_redirect!
    assert_template "projects/show"

    assert_not flash.empty?
    @bug.reload
    assert_match "closed", @bug.status
  end
end
