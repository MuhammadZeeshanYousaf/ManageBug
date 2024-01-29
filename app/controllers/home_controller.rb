class HomeController < ApplicationController
  def index
    if user_signed_in?
      @users = User.paginate(page: params[:page], per_page: 1)
      render "dashboard"
    else
      render "index"
    end
  end
end