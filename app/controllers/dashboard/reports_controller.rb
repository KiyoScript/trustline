# app/controllers/dashboard/reports_controller.rb
class Dashboard::ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @week_offset = params[:week_offset].to_i || 0

    today = Date.today
    @week_start = today.beginning_of_week + @week_offset.weeks
    @week_end   = @week_start.end_of_week
    @is_current = @week_offset == 0

    # Static data — replace with real queries later
    @leads_added   = 0
    @leads_removed = 0
    @net_growth    = 0
    @moved_forward = 0

    @team_summary = [] # No data this week

    @removals_by_reason = [] # No removals this week

    @alerts = [
      { label: "Overdue Actions",  count: 20, color: "text-error" },
      { label: "Stagnant (7+ days)", count: 16, color: "text-warning" }
    ]

    @leads_added_list   = [] # None added
    @leads_removed_list = [] # None removed
  end
end
