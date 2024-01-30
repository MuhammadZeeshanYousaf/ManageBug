require "test_helper"
include ActionDispatch::TestProcess

class ProjectTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_001)
    file = fixture_file_upload("test/fixtures/files/broom.png", "image/png")
    @project = Project.new(name: "New Project", details: "These are short details of project", image: file, creator_id: @user.id)
  end

  test "project should be valid" do
    assert @project.valid?
  end

  test "should save valid project" do
    assert @project.save
  end

  test "should not save project without name" do
    @project.name = " "
    assert_not @project.save
  end

  test "should not save project without picture" do
    project = Project.new(name: "Test Project", details: "Test project details")
    assert_not project.save
  end

  test "should not save project without creator_id" do
    @project.creator_id = " "
    assert_not @project.save
  end
  
end
