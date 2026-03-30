class Dashboard::PipelinesController < ApplicationController
  before_action :authenticate_user!

  STAGES = [
    "Sourced",
    "Contacted",
    "Engaged",
    "Qualified",
    "Call Booked",
    "Discovery Done",
    "Proposal Sent",
    "Negotiation / Follow-up"
  ].freeze

  STAGE_COLORS = {
    "Sourced"               => "text-base-content border-base-300",
    "Contacted"             => "text-blue-500 border-blue-200",
    "Engaged"               => "text-teal-500 border-teal-200",
    "Qualified"             => "text-green-500 border-green-200",
    "Call Booked"           => "text-pink-500 border-pink-200",
    "Discovery Done"        => "text-purple-500 border-purple-200",
    "Proposal Sent"         => "text-amber-500 border-amber-200",
    "Negotiation / Follow-up" => "text-orange-500 border-orange-200"
  }.freeze

  def index
    @stages = STAGES
    @stage_colors = STAGE_COLORS
    @leads = static_leads
    @leads_by_stage = @leads.group_by { |l| l[:stage] }
  end

  def create_lead
    # Placeholder — wire to Lead model later
    redirect_to pipeline_path, notice: "Lead added successfully."
  end

  private

  def static_leads
    [
      { company: "Harborview Legal",    contact: "Rachel Stone",    role: "agent",   date: "2026-03-26", source: "Apollo",   stage: "Sourced" },
      { company: "Quantum Labs",        contact: "Dr. Amy Foster",  role: "demo",    date: "2026-03-26", source: "Manual",   stage: "Sourced" },
      { company: "OmniHealth",          contact: "Dr. Patel",       role: "demo",    date: "2026-03-28", source: "Referral", stage: "Sourced" },
      { company: "ClearPath Logistics", contact: "Ahmed Suleiman",  role: "agent",   date: "2026-03-27", source: "LinkedIn", stage: "Contacted" },
      { company: "NovaTech",            contact: "Lisa Wang",       role: "demo",    date: "2026-03-28", source: "Website",  stage: "Contacted" },
      { company: "EduPlatform",         contact: "Maria Santos",    role: "demo",    date: "2026-03-20", source: "LinkedIn", stage: "Contacted" },
      { company: "CloudEdge Systems",   contact: "Patrick Wu",      role: "agent",   date: "2026-03-25", source: "LinkedIn", stage: "Engaged" },
      { company: "Vantage Pharma",      contact: "Grace Huang",     role: "manager", date: "2026-03-23", source: "Apollo",   stage: "Engaged" },
      { company: "Bright Solutions",    contact: "Mike O'Brien",    role: "demo",    date: "2026-03-26", source: "LinkedIn", stage: "Engaged" },
      { company: "Orion Fintech",       contact: "Lucas Ferreira",  role: "agent",   date: "2026-03-28", source: "LinkedIn", stage: "Qualified" },
      { company: "Acme Corp",           contact: "John Martinez",   role: "demo",    date: "2026-03-26", source: "LinkedIn", stage: "Qualified" },
      { company: "CloudNine Systems",   contact: "Alex Park",       role: "demo",    date: "2026-03-27", source: "Website",  stage: "Qualified" },
      { company: "Pinnacle Health",     contact: "Dr. Laura Kim",   role: "agent",   date: "2026-03-18", source: "Website",  stage: "Call Booked" },
      { company: "Summit Education",    contact: "Oliver Hayes",    role: "manager", date: "2026-03-27", source: "Website",  stage: "Call Booked" },
      { company: "FinServe Partners",   contact: "Emily Turner",    role: "demo",    date: "2026-03-27", source: "Apollo",   stage: "Call Booked" },
      { company: "TechFlow Inc",        contact: "Sarah Chen",      role: "demo",    date: "2026-03-27", source: "Apollo",   stage: "Discovery Done" },
      { company: "Apex Retail Group",   contact: "Michelle Torres", role: "manager", date: "2026-03-24", source: "Referral", stage: "Proposal Sent" },
      { company: "Skyline Developments", contact: "Daniel Brooks",   role: "manager", date: "2026-03-19", source: "Manual",   stage: "Proposal Sent" },
      { company: "Global Media",        contact: "David Kim",       role: "demo",    date: "2026-03-25", source: "Referral", stage: "Proposal Sent" },
      { company: "GreenPath Energy",    contact: "Tom Harris",      role: "demo",    date: "2026-03-28", source: "Referral", stage: "Negotiation / Follow-up" }
    ]
  end
end
