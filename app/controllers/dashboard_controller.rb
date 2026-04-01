class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    today        = Date.today
    week_start   = today.beginning_of_week
    week_end     = today.end_of_week
    month_start  = today.beginning_of_month
    month_end    = today.end_of_month

    base_leads = policy_scope_leads

    # ── KPI Cards ──────────────────────────────────────────────────────────────
    @active_leads_count    = base_leads.active_leads.count
    @added_this_week       = base_leads.where(date_added: week_start..week_end).count
    @removed_this_week     = base_leads.where(date_removed: week_start..week_end).count
    @net_growth_this_week  = @added_this_week - @removed_this_week
    @overdue_actions_count = base_leads.overdue.count

    @moved_forward_this_week = LeadMovementHistory
      .where(week_number: today.cweek, year: today.year)
      .where(action_type: :moved_stage)
      .where("new_stage > previous_stage")
      .count

    # Activities this week
    base_activities = policy_scope_activities
    @calls_this_week     = base_activities.this_week.call.count
    @proposals_this_week = base_activities.this_week.proposal_sent.count

    # Won / Lost this month
    @won_this_month  = base_leads.where(status: :won,  date_removed: month_start..month_end).count
    @lost_this_month = base_leads.where(status: :lost, date_removed: month_start..month_end).count

    # ── Charts ─────────────────────────────────────────────────────────────────
    # Pipeline stage distribution
    @stage_distribution = Lead.stages.keys.map do |stage|
      { stage: stage.humanize.gsub("_", " "), count: base_leads.active_leads.where(stage: stage).count }
    end

    # ── Alert Lists ────────────────────────────────────────────────────────────
    @overdue_leads = base_leads.overdue
                               .includes(:owner)
                               .order(:next_action_date)
                               .limit(5)

    @stagnant_7  = base_leads.stagnant_7_days
                              .includes(:owner)
                              .order(:last_contact_date)
                              .limit(5)

    @stagnant_14 = base_leads.stagnant_14_days
                              .includes(:owner)
                              .order(:last_contact_date)
                              .limit(5)

    # ── Top Producer This Week ─────────────────────────────────────────────────
    this_week_movements = LeadMovementHistory.this_week.includes(:changed_by)
    productivity = this_week_movements.group(:changed_by_id).count
    top_user_id  = productivity.max_by { |_, v| v }&.first
    @top_producer = top_user_id ? User.find_by(id: top_user_id) : nil
    @top_producer_count = productivity[top_user_id] || 0

    # ── Weekly Activity Feed (last 8 weeks added vs removed) ──────────────────
    @weekly_stats = (0..7).map do |weeks_ago|
      w_start = (today - weeks_ago.weeks).beginning_of_week
      w_end   = w_start.end_of_week
      {
        label:   w_start.strftime("W%W"),
        added:   base_leads.where(date_added: w_start..w_end).count,
        removed: base_leads.where(date_removed: w_start..w_end).count
      }
    end.reverse
  end

  private

  def policy_scope_leads
    if current_user.can_view_all_leads?
      Lead.all
    else
      Lead.where(owner: current_user).or(Lead.where(assigned_to: current_user))
    end
  end

  def policy_scope_activities
    if current_user.can_view_all_leads?
      Activity.all
    else
      Activity.where(user: current_user)
    end
  end
end
