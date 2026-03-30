# app/controllers/dashboard/settings_controller.rb
class Dashboard::SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
  end
end
