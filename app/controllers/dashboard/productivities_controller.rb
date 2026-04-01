class Dashboard::ProductivitiesController < ApplicationController
  before_action :authenticate_user!

  SCORING = {
    leads_added:    1,
    moved_forward:  2,
    follow_up:      1,
    call:           4,
    email:          1,
    linkedin:       1,
    meeting:        3,
    proposal_sent:  5,
    deal_won:       10
  }.freeze

  def index
    @period = params[:period] || "month"

    today = Date.today
    @date_range = case @period
    when "week"
                    today.beginning_of_week..today.end_of_week
    when "quarter"
                    today.beginning_of_quarter..today.end_of_quarter
    else # month
                    today.beginning_of_month..today.end_of_month
    end

    users = current_user.can_view_all_leads? ? User.where(active_status: true).order(:full_name) : [ current_user ]

    @agents = users.map { |user| build_agent_stats(user) }
                   .sort_by { |a| -a[:score] }

    @top_producer = @agents.first if @agents.any? && @agents.first[:score] > 0
  end

  private

  def build_agent_stats(user)
    # Leads added in period
    leads_added = Lead.where(created_by: user, date_added: @date_range).count

    # Leads moved forward in period
    moved_forward = LeadMovementHistory
                      .where(changed_by: user)
                      .where(action_type: :moved_stage)
                      .where("new_stage > previous_stage")
                      .where(created_at: @date_range)
                      .count

    # Leads removed
    leads_removed = Lead.where(last_updated_by: user, date_removed: @date_range).count

    # Activities breakdown
    activities = Activity.where(user: user, activity_date: @date_range)
    calls           = activities.call.count
    emails          = activities.email.count
    linkedin_msgs   = activities.linkedin_message.count
    meetings        = activities.meeting.count
    proposals       = activities.proposal_sent.count
    follow_ups      = activities.follow_up.count

    # Won deals
    deals_won = Lead.where(
      last_updated_by: user,
      status: :won,
      date_removed: @date_range
    ).count

    # Net leads
    net = leads_added - leads_removed

    # Productivity score
    score = (leads_added    * SCORING[:leads_added])   +
            (moved_forward  * SCORING[:moved_forward]) +
            (follow_ups     * SCORING[:follow_up])     +
            (calls          * SCORING[:call])          +
            (emails         * SCORING[:email])         +
            (linkedin_msgs  * SCORING[:linkedin])      +
            (meetings       * SCORING[:meeting])       +
            (proposals      * SCORING[:proposal_sent]) +
            (deals_won      * SCORING[:deal_won])

    {
      user:           user,
      score:          score,
      added:          leads_added,
      removed:        leads_removed,
      net:            net,
      fwd:            moved_forward,
      calls:          calls,
      emails:         emails,
      linkedin:       linkedin_msgs,
      meetings:       meetings,
      proposals:      proposals,
      follow_ups:     follow_ups,
      won:            deals_won,
      activities:     calls + emails + linkedin_msgs + meetings + proposals + follow_ups
    }
  end
end
