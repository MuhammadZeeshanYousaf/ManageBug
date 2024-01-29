class HomeController < ApplicationController
  def index
    if user_signed_in?
      @projects = Project.paginate(page: params[:page], per_page: 2)
      render "dashboard"
    else
      render "index"
    end
  end
end