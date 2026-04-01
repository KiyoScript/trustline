# app/models/activity.rb
class Activity < ApplicationRecord
  # ── Enums ──────────────────────────────────────────────────────────────────
  enum :activity_type, {
    call:             0,
    email:            1,
    linkedin_message: 2,
    meeting:          3,
    note:             4,
    proposal_sent:    5,
    follow_up:        6
  }

  # ── Associations ───────────────────────────────────────────────────────────
  belongs_to :lead
  belongs_to :user

  # ── Validations ─────────────────────────────────────────────────────────────
  validates :activity_type, presence: true
  validates :activity_date, presence: true
  validates :lead,          presence: true
  validates :user,          presence: true

  # ── Callbacks ───────────────────────────────────────────────────────────────
  after_create :update_lead_last_contact

  # ── Scopes ──────────────────────────────────────────────────────────────────
  scope :this_week,    -> { where(activity_date: Date.today.beginning_of_week..Date.today.end_of_week) }
  scope :this_month,   -> { where(activity_date: Date.today.beginning_of_month..Date.today.end_of_month) }
  scope :this_quarter, -> {
    start = Date.today.beginning_of_quarter
    finish = Date.today.end_of_quarter
    where(activity_date: start..finish)
  }
  scope :by_type,      ->(type) { where(activity_type: type) }
  scope :by_user,      ->(user) { where(user: user) }
  scope :recent,       -> { order(activity_date: :desc) }

  # ── Ransack allowlist ────────────────────────────────────────────────────────
  def self.ransackable_attributes(_auth_object = nil)
    %w[activity_type activity_date result notes next_step next_step_date]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[lead user]
  end

  # ── Helpers ──────────────────────────────────────────────────────────────────
  def type_label
    activity_type.to_s.humanize.gsub("_", " ")
  end

  def productivity_points
    case activity_type.to_sym
    when :call          then 4
    when :proposal_sent then 5
    when :meeting       then 3
    when :follow_up     then 1
    when :email         then 1
    when :linkedin_message then 1
    when :note          then 0
    else 0
    end
  end

  private

  def update_lead_last_contact
    lead.update_column(:last_contact_date, activity_date)
  end
end
