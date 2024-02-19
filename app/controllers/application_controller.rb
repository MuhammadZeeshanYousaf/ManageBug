class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    # redirect_back(fallback_location: root_path) #for page reloading and flash message displaying
    render file: Rails.root.join('public', '404.html'), layout: false, status: :not_found
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :role])
  end
end
