class Dashboard::PipelinesController < ApplicationController
  before_action :authenticate_user!

  STAGE_COLORS = {
    "sourced"               => { text: "text-base-content",  border: "border-base-300" },
    "contacted"             => { text: "text-blue-500",      border: "border-blue-200" },
    "engaged"               => { text: "text-teal-500",      border: "border-teal-200" },
    "qualified"             => { text: "text-green-500",     border: "border-green-200" },
    "call_booked"           => { text: "text-pink-500",      border: "border-pink-200" },
    "discovery_done"        => { text: "text-purple-500",    border: "border-purple-200" },
    "proposal_sent"         => { text: "text-amber-500",     border: "border-amber-200" },
    "negotiation_follow_up" => { text: "text-orange-500",   border: "border-orange-200" },
    "closed_won"            => { text: "text-green-600",     border: "border-green-300" },
    "closed_lost"           => { text: "text-red-400",       border: "border-red-200" }
  }.freeze

  def index
    base_scope = policy_scope_leads.active_leads
    @stages = Lead.stages.keys
    @stage_colors = STAGE_COLORS
    @leads_by_stage = base_scope
                        .includes(:owner, :assigned_to)
                        .group_by(&:stage)
  end

  def move_stage
    lead = policy_scope_leads.find(params[:lead_id])
    new_stage = params[:stage]

    unless Lead.stages.key?(new_stage)
      return render json: { error: "Invalid stage" }, status: :unprocessable_entity
    end

    old_stage = lead.stage

    lead.skip_movement_log = true
    if lead.update(stage: new_stage, last_updated_by: current_user)
      # Log movement history
      LeadMovementHistory.create!(
        lead:          lead,
        changed_by:    current_user,
        previous_stage: Lead.stages[old_stage],
        new_stage:     Lead.stages[new_stage],
        action_type:   :moved_stage,
        movement_note: "Stage moved from #{old_stage.humanize} to #{new_stage.humanize} via pipeline board",
        timestamp:     Time.current,
        week_number:   Date.today.cweek,
        month:         Date.today.month,
        quarter:       (Date.today.month / 3.0).ceil,
        year:          Date.today.year
      )
      render json: { success: true, lead_id: lead.id, new_stage: new_stage }
    else
      render json: { error: lead.errors.full_messages.join(", ") }, status: :unprocessable_entity
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
end
