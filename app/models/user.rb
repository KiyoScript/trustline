class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Scopes
  scope :active, -> { where(active_status: true) }

  # Roles
  enum :role, {
    super_admin: 0,
    admin:       1,
    manager:     2,
    agent:       3,
    viewer:      4
  }

  # Associations
  has_many :owned_leads,       class_name: "Lead", foreign_key: :owner_id,          dependent: :nullify
  has_many :assigned_leads,    class_name: "Lead", foreign_key: :assigned_to_id,     dependent: :nullify
  has_many :created_leads,     class_name: "Lead", foreign_key: :created_by_id,      dependent: :nullify
  has_many :lead_movements,    class_name: "LeadMovementHistory", foreign_key: :changed_by_id

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :role,  presence: true

  # Ransack allowlist
  def self.ransackable_attributes(_auth_object = nil)
    %w[full_name email role team active_status]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[owned_leads assigned_leads]
  end

  # Helpers
  def display_name
    full_name.presence || email.split("@").first.titleize
  end

  def initials
    if full_name.present?
      full_name.split.map(&:first).join.upcase[0..1]
    else
      email.first.upcase
    end
  end

  def can_manage_leads?
    super_admin? || admin? || manager? || agent?
  end

  def can_view_all_leads?
    super_admin? || admin? || manager?
  end

  def can_manage_team?
    super_admin? || admin?
  end
end
