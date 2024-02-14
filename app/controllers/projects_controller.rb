class ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    if params[:sort_by].present?
      if params[:sort_by] == "alphabet"
        @projects = current_user.get_user_project.order(name: :asc).paginate(page: params[:page], per_page: params[:per_page] || 6)
      elsif params[:sort_by] == "date_added"
        @projects = current_user.get_user_project.order(created_at: :asc).paginate(page: params[:page], per_page: params[:per_page] || 6)
      else
        @projects = current_user.get_user_project.paginate(page: params[:page], per_page: params[:per_page] || 6)
      end
    else
      @projects = current_user.get_user_project.paginate(page: params[:page], per_page: params[:per_page] || 6)
    end
    @project = Project.new
  end

  def new
  end

  def create
    @project = Project.new(project_params)
    @project.creator_id = current_user.id
    @projects = current_user.get_user_project.paginate(page: params[:page], per_page: params[:per_page] || 6)
    user = User.find_by(id: @project.creator_id)
    if user.role == "manager"
      if @project.save
        # binding.pry
        HardJob.perform_async(@project.users.pluck(:email))
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
    @project = Project.find(params[:id])
    @bug = Bug.new
  end

  private

  def project_params
    params.require(:project).permit(:name, :image, :details, user_ids: [])
  end
end
