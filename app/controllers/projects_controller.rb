class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.paginate(page: params[:page], per_page: 10)
    @project = Project.new
  end

  def new
  end

  def create
    @project = Project.new(project_params)
    @project.creator_id = current_user.id
    @projects = Project.paginate(page: params[:page], per_page: 10)
    user = User.find_by(id: @project.creator_id)
    if user.role == "manager"
      # debugger
      if @project.save
        flash[:success] = "New project created"
        redirect_to projects_path
      else
        flash[:danger] = "There's some error while saving the project"
        render :index, status: :unprocessable_entity
      end
    else
      flash[:danger] = "Only manager can create project"
      render :index, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :image, :details)
  end
end