module Authorizable
  extend ActiveSupport::Concern

  included do
    helper_method :can_manage_team?,
                  :can_view_all_leads?,
                  :can_manage_leads?,
                  :can_export?,
                  :can_access_reports?
  end

  def can_manage_team?
    current_user&.super_admin? || current_user&.admin?
  end

  def can_view_all_leads?
    current_user&.super_admin? || current_user&.admin? || current_user&.manager?
  end

  def can_manage_leads?
    current_user&.super_admin? || current_user&.admin? || current_user&.manager? || current_user&.agent?
  end

  def can_export?
    current_user&.super_admin? || current_user&.admin? || current_user&.manager?
  end

  def can_access_reports?
    current_user&.super_admin? || current_user&.admin? || current_user&.manager?
  end

  def require_admin!
    unless can_manage_team?
      redirect_to authenticated_root_path, alert: "You don't have permission to access this page."
    end
  end

  def require_manager!
    unless can_view_all_leads?
      redirect_to authenticated_root_path, alert: "You don't have permission to access this page."
    end
  end

  def require_agent!
    unless can_manage_leads?
      redirect_to authenticated_root_path, alert: "You don't have permission to access this page."
    end
  end
end
