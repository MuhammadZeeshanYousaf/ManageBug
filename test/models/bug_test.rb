require "test_helper"
include ActionDispatch::TestProcess

class BugTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_001)
    @user2 = users(:user_002)
    @user3 = users(:user_003)
    @file = fixture_file_upload("test/fixtures/files/broom.png", "image/png")
    @project = Project.new(name: "New Project", details: "These are short details of project", image: @file, creator_id: @user.id)
    @project.save
    @bug = Bug.new(title: "Bug 1", description: "Test description", deadline: 10.days.from_now,
                   bug_type: 0, status: 0, creator_id: @user3.id, project_id: @project.id, user_id: @user2.id, screenshot: @file)
  end

  test "should be valid" do
    assert @bug.valid?
  end

  test "should save a valid bug" do
    assert @bug.save
  end

  test "Title should be present" do
    @bug.title = " "
    assert_not @bug.save
  end

  test "Project id should be present" do
    @bug.project_id = " "
    assert_not @bug.save
  end

  test "Deadline cannot be in past" do
    @bug.deadline = Time.now - 1.month
    assert_not @bug.save
  end

  test "Bug title should be unique with in the scope of project" do
    assert @bug.save
    @bug_same = Bug.new(title: "Bug 1", description: "Test description", deadline: 10.days.from_now,
                        bug_type: 0, status: 0, creator_id: @user3.id, project_id: @project.id, user_id: @user2.id, screenshot: @file)
    assert_not @bug_same.save
  end

  test "Bug title can be same in other projects" do
    assert @bug.save
    @project2 = Project.new(name: "New Project 2", details: "These are short details of project 2", image: @file, creator_id: @user.id)
    assert @project2.save
    @bug2 = Bug.new(title: "Bug 1", description: "Test description", deadline: 10.days.from_now,
                    bug_type: 0, status: 0, creator_id: @user3.id, project_id: @project2.id, user_id: @user2.id, screenshot: @file)
    assert @bug2.save
  end
end
