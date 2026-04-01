require "csv"

class Dashboard::ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @week_offset = params[:week_offset].to_i

    today        = Date.today
    @week_start  = (today + @week_offset.weeks).beginning_of_week
    @week_end    = @week_start.end_of_week
    @is_current  = @week_offset == 0
    @week_number = @week_start.cweek
    @year        = @week_start.year

    base_leads = policy_scope_leads

    # ── KPI Numbers ───────────────────────────────────────────────────────────
    @leads_added_list   = base_leads
                            .where(date_added: @week_start..@week_end)
                            .includes(:owner, :assigned_to)
                            .order(:company_name)

    @leads_removed_list = base_leads
                            .where(date_removed: @week_start..@week_end)
                            .includes(:owner)
                            .order(:company_name)

    @leads_added   = @leads_added_list.count
    @leads_removed = @leads_removed_list.count
    @net_growth    = @leads_added - @leads_removed

    @moved_forward = LeadMovementHistory
                       .where(week_number: @week_number, year: @year)
                       .where(action_type: :moved_stage)
                       .where("new_stage > previous_stage")
                       .count

    # ── Team Summary ──────────────────────────────────────────────────────────
    users = current_user.can_view_all_leads? ? User.where(active_status: true) : [ current_user ]

    @team_summary = users.map do |user|
      added      = base_leads.where(created_by: user, date_added: @week_start..@week_end).count
      removed    = base_leads.where(last_updated_by: user, date_removed: @week_start..@week_end).count
      moved      = LeadMovementHistory
                     .where(changed_by: user, week_number: @week_number, year: @year)
                     .where(action_type: :moved_stage)
                     .count
      activities = Activity.where(user: user, activity_date: @week_start..@week_end).count

      {
        user:       user,
        added:      added,
        removed:    removed,
        moved:      moved,
        activities: activities,
        total:      added + moved + activities
      }
    end.select { |s| s[:total] > 0 }.sort_by { |s| -s[:total] }

    # ── Removals by Reason ────────────────────────────────────────────────────
    @removals_by_reason = @leads_removed_list
                            .pluck(:removal_reason)
                            .group_by(&:itself)
                            .map { |reason, arr| { reason: reason.presence || "Not specified", count: arr.size } }
                            .sort_by { |r| -r[:count] }

    # ── Alerts ────────────────────────────────────────────────────────────────
    @overdue_count   = base_leads.overdue.count
    @stagnant_count  = base_leads.stagnant_7_days.count

    # CSV export
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv, filename: "weekly_report_#{@week_start}.csv" }
    end
  end

  private

  def policy_scope_leads
    if current_user.can_view_all_leads?
      Lead.all
    else
      Lead.where(owner: current_user).or(Lead.where(assigned_to: current_user))
    end
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << [ "Week", "#{@week_start} — #{@week_end}" ]
      csv << []
      csv << [ "SUMMARY" ]
      csv << [ "Leads Added", @leads_added ]
      csv << [ "Leads Removed", @leads_removed ]
      csv << [ "Net Growth", @net_growth ]
      csv << [ "Moved Forward", @moved_forward ]
      csv << []
      csv << [ "LEADS ADDED THIS WEEK" ]
      csv << [ "Company", "Contact", "Stage", "Source", "Owner" ]
      @leads_added_list.each do |lead|
        csv << [ lead.company_name, lead.contact_name, lead.stage.humanize, lead.source.humanize, lead.owner&.display_name ]
      end
      csv << []
      csv << [ "LEADS REMOVED THIS WEEK" ]
      csv << [ "Company", "Contact", "Reason", "Removed By" ]
      @leads_removed_list.each do |lead|
        csv << [ lead.company_name, lead.contact_name, lead.removal_reason, lead.last_updated_by&.display_name ]
      end
      csv << []
      csv << [ "TEAM SUMMARY" ]
      csv << [ "Agent", "Added", "Removed", "Moved", "Activities" ]
      @team_summary.each do |s|
        csv << [ s[:user].display_name, s[:added], s[:removed], s[:moved], s[:activities] ]
      end
    end
  end
end
