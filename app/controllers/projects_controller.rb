class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: :show
  authorize_resource

  def index
    @projects = current_user.get_user_project.paginate(page: params[:page], per_page: 10)
    @project = Project.new
  end

  def new
  end

  def create
    @project = Project.new(project_params)
    @project.creator_id = current_user.id
    @projects = current_user.get_user_project.paginate(page: params[:page], per_page: 10)
    user = User.find_by(id: @project.creator_id)
    if user.role == "manager"
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

  def show
    @bug = Bug.new
  end

  private

  def project_params
    params.require(:project).permit(:name, :image, :details, user_ids: [])
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
