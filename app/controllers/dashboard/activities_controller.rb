# app/controllers/dashboard/activities_controller.rb
class Dashboard::ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [ :show, :edit, :update, :destroy ]
  include Pagy::Method

  ACTIVITY_TYPES = Activity.activity_types.keys.freeze

  def index
    base_scope = policy_scope_activities

    @query = base_scope.ransack(params[:query])
    @query.sorts = "activity_date desc" if @query.sorts.empty?

    @active_tab = params[:tab].presence || "call"
    tab_scope = @query.result(distinct: true)
                      .includes(:lead, :user)
                      .where(activity_type: Activity.activity_types[@active_tab])

    @pagy, @activities = pagy(:offset, tab_scope, items: 20)

    all_activities = base_scope
    @counts = Activity.activity_types.keys.index_with do |type|
      all_activities.where(activity_type: type).count
    end

    @this_week_count  = base_scope.this_week.count
    @this_month_count = base_scope.this_month.count
  end

  def show
  end

  def edit
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.user = current_user

    if @activity.save
      redirect_to dashboard_activities_path(tab: @activity.activity_type),
                  notice: "Activity logged successfully."
    else
      redirect_to dashboard_activities_path,
                  alert: "Failed to log activity: #{@activity.errors.full_messages.join(', ')}"
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to dashboard_activities_path(tab: @activity.activity_type),
                  notice: "Activity updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    tab = @activity.activity_type
    @activity.destroy
    redirect_to dashboard_activities_path(tab: tab),
                notice: "Activity deleted."
  end

  private

  def set_activity
    @activity = policy_scope_activities.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_activities_path, alert: "Activity not found."
  end

  def policy_scope_activities
    if current_user.can_view_all_leads?
      Activity.all
    else
      Activity.where(user: current_user)
    end
  end

  def activity_params
    params.require(:activity).permit(
      :lead_id, :activity_type, :activity_date,
      :result, :notes, :next_step, :next_step_date
    )
  end
end
