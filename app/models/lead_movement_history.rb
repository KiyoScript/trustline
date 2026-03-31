class LeadMovementHistory < ApplicationRecord
  # ── Enums ──────────────────────────────────────────────────────────────────
  enum :action_type, {
    created:      0,
    updated:      1,
    moved_stage:  2,
    reassigned:   3,
    removed:      4,
    reactivated:  5,
    won:          6,
    lost:         7
  }

  # ── Associations ───────────────────────────────────────────────────────────
  belongs_to :lead
  belongs_to :changed_by, class_name: "User", foreign_key: :changed_by_id

  # ── Validations ─────────────────────────────────────────────────────────────
  validates :action_type, presence: true
  validates :timestamp,   presence: true
  validates :changed_by,  presence: true

  # ── Scopes ──────────────────────────────────────────────────────────────────
  scope :this_week,    -> { where(week_number: Date.today.cweek, year: Date.today.year) }
  scope :this_month,   -> { where(month: Date.today.month, year: Date.today.year) }
  scope :this_quarter, -> { where(quarter: (Date.today.month / 3.0).ceil, year: Date.today.year) }
  scope :stage_moves,  -> { where(action_type: :moved_stage) }
  scope :forward_moves, -> {
    where(action_type: :moved_stage)
      .where("new_stage > previous_stage")
  }

  # ── Ransack allowlist ────────────────────────────────────────────────────────
  def self.ransackable_attributes(_auth_object = nil)
    %w[action_type week_number month quarter year timestamp]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[lead changed_by]
  end

  # ── Helpers ──────────────────────────────────────────────────────────────────
  def previous_stage_label
    return "—" unless previous_stage
    Lead.stages.key(previous_stage).to_s.humanize
  end

  def new_stage_label
    return "—" unless new_stage
    Lead.stages.key(new_stage).to_s.humanize
  end

  def moved_forward?
    moved_stage? && new_stage.present? && previous_stage.present? && new_stage > previous_stage
  end
end
