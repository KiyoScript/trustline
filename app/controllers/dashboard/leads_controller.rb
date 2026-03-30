# app/controllers/dashboard/leads_controller.rb
class Dashboard::LeadsController < ApplicationController
  before_action :authenticate_user!

  STAGES = [
    "Sourced", "Contacted", "Engaged", "Qualified",
    "Call Booked", "Discovery Done", "Proposal Sent", "Negotiation / Follow-up"
  ].freeze

  STAGE_COLORS = {
    "Sourced"                 => "badge-ghost",
    "Contacted"               => "badge-info",
    "Engaged"                 => "badge-success",
    "Qualified"               => "badge-primary",
    "Call Booked"             => "badge-secondary",
    "Discovery Done"          => "badge-accent",
    "Proposal Sent"           => "badge-warning",
    "Negotiation / Follow-up" => "badge-error"
  }.freeze

  def index
    @leads = static_leads
  end

  private

  def static_leads
    [
      { company: "Pinnacle Health",      contact: "Dr. Laura Kim",   stage: "Call Booked",    status: "Active", source: "Website",  owner: "agent",   date: "2026-03-18" },
      { company: "ClearPath Logistics",  contact: "Ahmed Suleiman",  stage: "Contacted",       status: "Active", source: "LinkedIn", owner: "agent",   date: "2026-03-27" },
      { company: "Apex Retail Group",    contact: "Michelle Torres", stage: "Proposal Sent",   status: "Active", source: "Referral", owner: "manager", date: "2026-03-24" },
      { company: "CloudEdge Systems",    contact: "Patrick Wu",      stage: "Engaged",         status: "Active", source: "LinkedIn", owner: "agent",   date: "2026-03-25" },
      { company: "Harborview Legal",     contact: "Rachel Stone",    stage: "Sourced",         status: "Active", source: "Apollo",   owner: "agent",   date: "2026-03-26" },
      { company: "Skyline Developments", contact: "Daniel Brooks",   stage: "Proposal Sent",   status: "Active", source: "Manual",   owner: "manager", date: "2026-03-19" },
      { company: "Vantage Pharma",       contact: "Grace Huang",     stage: "Engaged",         status: "Active", source: "Apollo",   owner: "manager", date: "2026-03-23" },
      { company: "Orion Fintech",        contact: "Lucas Ferreira",  stage: "Qualified",       status: "Active", source: "LinkedIn", owner: "agent",   date: "2026-03-28" },
      { company: "Summit Education",     contact: "Oliver Hayes",    stage: "Call Booked",     status: "Active", source: "Website",  owner: "manager", date: "2026-03-27" },
      { company: "Acme Corp",            contact: "John Martinez",   stage: "Qualified",       status: "Active", source: "LinkedIn", owner: "demo",    date: "2026-03-26" },
      { company: "TechFlow Inc",         contact: "Sarah Chen",      stage: "Discovery Done",  status: "Active", source: "Apollo",   owner: "demo",    date: "2026-03-27" },
      { company: "Global Media",         contact: "David Kim",       stage: "Proposal Sent",   status: "Active", source: "Referral", owner: "demo",    date: "2026-03-25" },
      { company: "NovaTech",             contact: "Lisa Wang",       stage: "Contacted",       status: "Active", source: "Website",  owner: "demo",    date: "2026-03-28" },
      { company: "Bright Solutions",     contact: "Mike O'Brien",    stage: "Engaged",         status: "Active", source: "LinkedIn", owner: "demo",    date: "2026-03-26" },
      { company: "Quantum Labs",         contact: "Dr. Amy Foster",  stage: "Sourced",         status: "Active", source: "Manual",   owner: "demo",    date: "2026-03-26" },
      { company: "OmniHealth",           contact: "Dr. Patel",       stage: "Sourced",         status: "Active", source: "Referral", owner: "demo",    date: "2026-03-28" },
      { company: "EduPlatform",          contact: "Maria Santos",    stage: "Contacted",       status: "Active", source: "LinkedIn", owner: "demo",    date: "2026-03-20" },
      { company: "CloudNine Systems",    contact: "Alex Park",       stage: "Qualified",       status: "Active", source: "Website",  owner: "demo",    date: "2026-03-27" },
      { company: "FinServe Partners",    contact: "Emily Turner",    stage: "Call Booked",     status: "Active", source: "Apollo",   owner: "demo",    date: "2026-03-27" },
      { company: "GreenPath Energy",     contact: "Tom Harris",      stage: "Negotiation / Follow-up", status: "Active", source: "Referral", owner: "demo", date: "2026-03-28" }
    ]
  end
end
