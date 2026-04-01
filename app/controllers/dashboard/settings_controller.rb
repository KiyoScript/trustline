class Dashboard::SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def update_profile
    if current_user.update(profile_params)
      redirect_to dashboard_settings_path, notice: "Profile updated successfully."
    else
      redirect_to dashboard_settings_path, alert: "Failed to update profile: #{current_user.errors.full_messages.join(', ')}"
    end
  end

  def update_password
    if current_user.update_with_password(password_params)
      # Re-sign in to avoid Devise logging out after password change
      bypass_sign_in(current_user)
      redirect_to dashboard_settings_path, notice: "Password updated successfully."
    else
      redirect_to dashboard_settings_path, alert: "Failed to update password: #{current_user.errors.full_messages.join(', ')}"
    end
  end

  private

  def profile_params
    params.require(:user).permit(:full_name, :email, :team)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
