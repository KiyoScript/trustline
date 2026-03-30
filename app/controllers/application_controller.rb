class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes


  private

  def record_not_found
    redirect_to root_path, alert: "Record not found."
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
