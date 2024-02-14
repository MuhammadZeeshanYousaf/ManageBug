class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_back(fallback_location: root_path) #for page reloading and flash message displaying
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :role])
  end
end
