class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:user_type, :user_name, :email, :password, :password_confirmation, :remember_me, :current_password]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def after_sign_in_path_for(resource)
    return rails_admin_url if current_user.admin?
    url_for current_user_type
  end

  def current_user_type
    user = current_user.user_type
    user.camelize.constantize
  end
end
