class HomeController < ApplicationController
  def index
    if user_signed_in?
      render "dashboard"
    else
      render "index"
    end
  end
end