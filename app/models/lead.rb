class Lead < ApplicationRecord
  # ── Enums ──────────────────────────────────────────────────────────────────
  enum :source, {
    linkedin:  0,
    apollo:    1,
    referral:  2,
    website:   3,
    manual:    4,
    other:     5
  }

  enum :stage, {
    sourced:               0,
    contacted:             1,
    engaged:               2,
    qualified:             3,
    call_booked:           4,
    discovery_done:        5,
    proposal_sent:         6,
    negotiation_follow_up: 7,
    closed_won:            8,
    closed_lost:           9
  }

  enum :status, {
    active:  0,
    won:     1,
    lost:    2,
    removed: 3
  }

  # ── Associations ───────────────────────────────────────────────────────────
  belongs_to :owner,          class_name: "User", foreign_key: :owner_id
  belongs_to :assigned_to,    class_name: "User", foreign_key: :assigned_to_id, optional: true
  belongs_to :created_by,     class_name: "User", foreign_key: :created_by_id
  belongs_to :last_updated_by, class_name: "User", foreign_key: :last_updated_by_id, optional: true

  has_many :movement_histories, class_name: "LeadMovementHistory", dependent: :destroy
  has_many :activities, dependent: :destroy

  # ── Validations ─────────────────────────────────────────────────────────────
  validates :company_name, presence: true
  validates :contact_name, presence: true
  validates :owner,        presence: true
  validates :stage,        presence: true
  validates :status,       presence: true
  validates :removal_reason, presence: true, if: :removed?

  # ── Callbacks ───────────────────────────────────────────────────────────────
  before_create :set_date_added
  before_save   :log_stage_change, if: :stage_changed?
  before_save   :log_status_change, if: :status_changed?

  # ── Scopes ──────────────────────────────────────────────────────────────────
  scope :active_leads,    -> { where(status: :active) }
  scope :overdue,         -> { where("next_action_date < ? AND status = ?", Date.today, statuses[:active]) }
  scope :stagnant_7_days, -> { where("last_contact_date < ? AND status = ?", 7.days.ago.to_date, statuses[:active]) }
  scope :stagnant_14_days, -> { where("last_contact_date < ? AND status = ?", 14.days.ago.to_date, statuses[:active]) }
  scope :added_this_week, -> { where(date_added: Date.today.beginning_of_week..Date.today.end_of_week) }
  scope :removed_this_week, -> { where(date_removed: Date.today.beginning_of_week..Date.today.end_of_week) }

  # ── Ransack allowlist ────────────────────────────────────────────────────────
  def self.ransackable_attributes(_auth_object = nil)
    %w[
      company_name contact_name email phone job_title
      source stage status industry
      next_action_date date_added date_removed
      lead_value_estimate tags notes
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[owner assigned_to created_by]
  end

  # ── Helpers ──────────────────────────────────────────────────────────────────
  def overdue?
    next_action_date.present? && next_action_date < Date.today && active?
  end

  def stage_label
    stage.to_s.humanize.gsub("_", " ")
  end

  def days_since_last_contact
    return nil unless last_contact_date
    (Date.today - last_contact_date).to_i
  end

  private

  def set_date_added
    self.date_added ||= Date.today
  end

  def log_stage_change
    return unless persisted?
    movement_histories.build(
      changed_by:     last_updated_by || created_by,
      previous_stage: stage_was ? Lead.stages[stage_was] : nil,
      new_stage:      Lead.stages[stage],
      action_type:    :moved_stage,
      movement_note:  "Stage changed from #{stage_was&.humanize} to #{stage.humanize}",
      timestamp:      Time.current,
      week_number:    Date.today.cweek,
      month:          Date.today.month,
      quarter:        (Date.today.month / 3.0).ceil,
      year:           Date.today.year
    )
  end

  def log_status_change
    return unless persisted?
    action = case status
    when "won"     then :won
    when "lost"    then :lost
    when "removed" then :removed
    else :updated
    end

    movement_histories.build(
      changed_by:      last_updated_by || created_by,
      previous_status: status_was ? Lead.statuses[status_was] : nil,
      new_status:      Lead.statuses[status],
      action_type:     action,
      movement_note:   "Status changed from #{status_was&.humanize} to #{status.humanize}",
      timestamp:       Time.current,
      week_number:     Date.today.cweek,
      month:           Date.today.month,
      quarter:         (Date.today.month / 3.0).ceil,
      year:            Date.today.year
    )
  end
end
