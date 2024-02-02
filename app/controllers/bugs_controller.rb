class BugsController < ApplicationController
  def index
  end

  def new
    @bug = Bug.new
  end

  def create
    @bug = Bug.new(bug_params)
    @project = Project.find(params[:bug][:project_id])
    @bug.status = 0
    @bug.creator_id = current_user.id
    @bug.bug_type = "bug"
    if current_user.role == "QA"
      if @bug.save
        flash[:success] = "New Bug Added"
        redirect_to @project
      else
        flash[:danger] = "There's some error while saving the bug"
        render "projects/show", status: :unprocessable_entity
      end
    else
      flash[:danger] = "Only QA can create project"
      render "projects/show", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end

  private

  def bug_params
    params.require(:bug).permit(:title, :description, :user_id, :project_id, :image, :deadline)
  end
end
