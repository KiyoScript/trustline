class ApplicationController < ActionController::Base
  include Pagy::Method
  include Authorizable

  before_action :configure_permitted_parameters, if: :devise_controller?
  allow_browser versions: :modern

  stale_when_importmap_changes


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :full_name, :role, :team ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name, :team, :phone ])
  end

  def record_not_found
    redirect_to root_path, alert: "Record not found."
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
