class Dashboard::TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_member, only: [ :edit, :update, :destroy, :toggle_status ]

  def index
    @query = User.ransack(params[:query])
    @query.sorts = "full_name asc" if @query.sorts.empty?
    @pagy, @members = pagy(:offset, @query.result(distinct: true), items: 20)

    @total_count   = User.count
    @admin_count   = User.where(role: [ :super_admin, :admin, :manager ]).count
    @agent_count   = User.agent.count
    @active_count  = User.where(active_status: true).count
  end

  def new
    @member = User.new
  end

  def create
    @member = User.new(invite_params)
    @member.password              = SecureRandom.hex(12)
    @member.password_confirmation = @member.password

    if @member.save
      redirect_to dashboard_teams_path, notice: "#{@member.display_name} has been added to the team."
    else
      @query = User.ransack({})
      @pagy, @members = pagy(:offset, User.all, items: 20)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @member.update(update_params)
      redirect_to dashboard_teams_path, notice: "#{@member.display_name} updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_status
    new_status = !@member.active_status
    @member.update!(active_status: new_status)
    status_label = new_status ? "activated" : "deactivated"
    redirect_to dashboard_teams_path, notice: "#{@member.display_name} has been #{status_label}."
  end

  def destroy
    if @member == current_user
      redirect_to dashboard_teams_path, alert: "You cannot remove yourself."
      return
    end
    @member.update!(active_status: false)
    redirect_to dashboard_teams_path, notice: "#{@member.display_name} has been deactivated."
  end

  private

  def set_member
    @member = User.find(params[:id])
  end

  def require_admin!
    unless current_user.super_admin? || current_user.admin?
      redirect_to authenticated_root_path, alert: "Access denied."
    end
  end

  def invite_params
    params.require(:user).permit(:full_name, :email, :role, :team, :hire_date, :active_status)
  end

  def update_params
    params.require(:user).permit(:full_name, :email, :role, :team, :hire_date, :active_status)
  end
end
