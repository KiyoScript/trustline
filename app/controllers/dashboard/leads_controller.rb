class Dashboard::LeadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lead, only: [ :show, :edit, :update, :destroy ]

  def index
    base_scope = policy_scope_leads

    @query = base_scope.ransack(params[:query])
    @query.sorts = "date_added desc" if @query.sorts.empty?

    @pagy, @leads = pagy(:offset, @query.result(distinct: true).includes(:owner, :assigned_to, :created_by), items: 20)
  end

  def show
    @movement_histories = @lead.movement_histories.includes(:changed_by).order(timestamp: :desc)
    @activities         = @lead.activities.includes(:user).order(activity_date: :desc) rescue []
  end

  def edit
  end

  def create
    @lead = Lead.new(lead_params)
    @lead.created_by      = current_user
    @lead.last_updated_by = current_user
    @lead.owner           = current_user if @lead.owner_id.blank?
    @lead.date_added      = Date.today

    if @lead.save
      @lead.movement_histories.create!(
        changed_by:    current_user,
        new_stage:     Lead.stages[@lead.stage],
        new_status:    Lead.statuses[@lead.status],
        action_type:   :created,
        movement_note: "Lead created",
        timestamp:     Time.current,
        week_number:   Date.today.cweek,
        month:         Date.today.month,
        quarter:       (Date.today.month / 3.0).ceil,
        year:          Date.today.year
      )
      redirect_to dashboard_leads_path, notice: "Lead added successfully."
    else
      redirect_to dashboard_leads_path, alert: "Failed to add lead: #{@lead.errors.full_messages.join(', ')}"
    end
  end

  def update
    @lead.last_updated_by = current_user
    @lead.skip_movement_log = false

    if @lead.update(lead_params)
      # Log reassignment if owner changed
      if @lead.saved_change_to_owner_id?
        @lead.movement_histories.create!(
          changed_by:    current_user,
          action_type:   :reassigned,
          movement_note: "Lead reassigned",
          timestamp:     Time.current,
          week_number:   Date.today.cweek,
          month:         Date.today.month,
          quarter:       (Date.today.month / 3.0).ceil,
          year:          Date.today.year
        )
      end

      redirect_to dashboard_lead_path(@lead), notice: "Lead updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Never hard delete — mark as removed
    if @lead.update(
      status:           :removed,
      date_removed:     Date.today,
      removal_reason:   params[:removal_reason].presence || "Removed by #{current_user.display_name}",
      last_updated_by:  current_user
    )
      @lead.movement_histories.create!(
        changed_by:      current_user,
        previous_status: Lead.statuses["active"],
        new_status:      Lead.statuses["removed"],
        action_type:     :removed,
        movement_note:   "Lead removed: #{@lead.removal_reason}",
        timestamp:       Time.current,
        week_number:     Date.today.cweek,
        month:           Date.today.month,
        quarter:         (Date.today.month / 3.0).ceil,
        year:            Date.today.year
      )
      redirect_to dashboard_leads_path, notice: "Lead marked as removed."
    else
      redirect_to dashboard_leads_path, alert: "Failed to remove lead."
    end
  end

  private

  def set_lead
    @lead = policy_scope_leads.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_leads_path, alert: "Lead not found."
  end

  def policy_scope_leads
    if current_user.can_view_all_leads?
      Lead.all
    else
      Lead.where(owner: current_user).or(Lead.where(assigned_to: current_user))
    end
  end

  def lead_params
    params.require(:lead).permit(
      :company_name, :contact_name, :job_title, :email, :phone,
      :source, :industry, :assigned_to_id, :owner_id,
      :stage, :status, :lead_value_estimate,
      :last_contact_date, :next_action, :next_action_date,
      :notes, :removal_reason,
      tags: []
    )
  end
end
