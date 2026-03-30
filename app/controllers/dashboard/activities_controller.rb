# app/controllers/dashboard/activities_controller.rb
class Dashboard::ActivitiesController < ApplicationController
  before_action :authenticate_user!

  ACTIVITY_TYPES = [
    "Call", "Email", "LinkedIn Message", "Meeting", "Note", "Proposal Sent", "Follow-up"
  ].freeze

  def index
    @activities = static_activities
    @grouped = @activities.group_by { |a| a[:type] }
    @counts = {
      "Call"             => @grouped["Call"]&.size || 0,
      "Email"            => @grouped["Email"]&.size || 0,
      "LinkedIn Message" => @grouped["LinkedIn Message"]&.size || 0,
      "Meeting"          => @grouped["Meeting"]&.size || 0,
      "Note"             => @grouped["Note"]&.size || 0,
      "Proposal Sent"    => @grouped["Proposal Sent"]&.size || 0,
      "Follow-up"        => @grouped["Follow-up"]&.size || 0
    }

    today = Date.today
    start_of_week  = today.beginning_of_week
    start_of_month = today.beginning_of_month

    @this_week_count  = @activities.count { |a| Date.parse(a[:date]) >= start_of_week }
    @this_month_count = @activities.count { |a| Date.parse(a[:date]) >= start_of_month }
  end

  private

  def static_activities
    [
      { type: "Call",             company: "GreenPath Energy",     contact: "Tom Harris",      notes: "Reviewing final contract terms, legal involved",                                   result: "In Progress",                       next_step: "Final contract review",    next_date: "2026-03-28", date: "2026-03-24", by: "Demo User" },
      { type: "Call",             company: "Acme Corp",            contact: "John Martinez",   notes: "Discussed enterprise pricing, very interested",                                    result: "Positive",                          next_step: "Send proposal",            next_date: "2026-03-26", date: "2026-03-22", by: "Demo User" },
      { type: "Call",             company: "FinServe Partners",    contact: "Emily Turner",    notes: "Brief intro call, very interested in enterprise features",                         result: "Interested",                        next_step: nil,                        next_date: nil,          date: "2026-03-19", by: "Demo User" },
      { type: "Call",             company: "TechVault Solutions",  contact: "Marcus Reid",     notes: "Discussed technical requirements. Full API integration needed. Budget approved Q2.", result: "Very positive — CTO engaged",      next_step: "Send formal proposal",     next_date: "2026-03-20", date: "2026-03-18", by: "Jordan Mitchell" },
      { type: "Call",             company: "Vantage Pharma",       contact: "Grace Huang",     notes: "Compliance-heavy environment. Need to emphasize security certifications in proposal.", result: "Interested in full platform",    next_step: "Send case studies",        next_date: "2026-03-23", date: "2026-03-16", by: "Demo User" },
      { type: "Call",             company: "Pinnacle Health",      contact: "Dr. Laura Kim",   notes: "Discussed integration with existing EMR system",                                   result: "Needs demo",                        next_step: "Schedule demo",            next_date: "2026-03-25", date: "2026-03-14", by: "Demo User" },
      { type: "Email",            company: "FinServe Partners",    contact: "Emily Turner",    notes: "Confirmed discovery call for March 27",                                            result: "Confirmed",                         next_step: "Discovery call",           next_date: "2026-03-27", date: "2026-03-23", by: "Demo User" },
      { type: "Email",            company: "NovaBuild Corp",       contact: "Sarah Chen",      notes: "Sent calendar invite for Thursday 3pm. Sarah mentioned she'd loop in her ops team.", result: "Confirmed call date",             next_step: "Prep discovery agenda",    next_date: nil,          date: "2026-03-20", by: "Jordan Mitchell" },
      { type: "Email",            company: "ClearPath Logistics",  contact: "Ahmed Suleiman",  notes: "Sent intro email with product overview PDF. Ahmed opened it 3 times.",              result: "Initial contact made",              next_step: "Follow up call",           next_date: "2026-03-27", date: "2026-03-19", by: "Demo User" },
      { type: "Email",            company: "Quantum Labs",         contact: "Dr. Amy Foster",  notes: "Responded to inbound inquiry. Sent pricing tiers",                                 result: "Interested",                        next_step: "Book intro call",          next_date: "2026-03-26", date: "2026-03-17", by: "Demo User" },
      { type: "Email",            company: "Summit Education",     contact: "Oliver Hayes",    notes: "Followed up after no response. He replied same day",                               result: "Re-engaged",                        next_step: "Call this week",           next_date: "2026-03-28", date: "2026-03-15", by: "Demo User" },
      { type: "Email",            company: "Apex Retail Group",    contact: "Michelle Torres", notes: "Sent revised pricing proposal after negotiation",                                  result: "Under review",                      next_step: "Follow up",                next_date: "2026-03-29", date: "2026-03-13", by: "Jordan Mitchell" },
      { type: "LinkedIn Message", company: "Bright Solutions",     contact: "Mike O'Brien",    notes: "Connected on LinkedIn, scheduling call",                                           result: "Replied",                           next_step: "Qualification call",       next_date: "2026-03-26", date: "2026-03-21", by: "Demo User" },
      { type: "LinkedIn Message", company: "CloudEdge Systems",    contact: "Patrick Wu",      notes: "Initial outreach on LinkedIn. Patrick confirmed interest and asked for product details.", result: "Responded positively",          next_step: "Schedule product demo",    next_date: "2026-03-25", date: "2026-03-17", by: "Alex Rivera" },
      { type: "Meeting",          company: "TechFlow Inc",         contact: "Sarah Chen",      notes: "Full technical requirements gathered, CTO aligned",                                result: "Completed discovery",               next_step: "Schedule demo",            next_date: "2026-03-27", date: "2026-03-20", by: "Demo User" },
      { type: "Meeting",          company: "Meridian Capital",     contact: "James Okafor",    notes: "In-person meeting. They want a 10% discount. Decision expected by end of month.",  result: "Strong interest, price negotiation started", next_step: "Revised proposal", next_date: "2026-03-22", date: "2026-03-15", by: "Taylor Brooks" },
      { type: "Proposal Sent",    company: "Global Media",         contact: "David Kim",       notes: "Custom proposal for 24-month plan",                                                result: "Sent",                              next_step: "Follow up on proposal",    next_date: "2026-03-25", date: "2026-03-18", by: "Demo User" },
      { type: "Proposal Sent",    company: "Skyline Developments", contact: "Daniel Brooks",   notes: "Board reviewing on 21st. Price was accepted in principle.",                        result: "Proposal delivered — $95k scope",   next_step: "Negotiate contract terms", next_date: "2026-03-19", date: "2026-03-10", by: "Taylor Brooks" },
      { type: "Follow-up",        company: "ClearPath Logistics",  contact: "Ahmed Suleiman",  notes: "client ask me to call today but got voice mail 7 times",                           result: "voice mail",                        next_step: "call again monday",        next_date: "2026-03-30", date: "2026-03-27", by: "Cymon Trillana" },
      { type: "Follow-up",        company: "CloudNine Systems",    contact: "Alex Park",       notes: "Technical spec discussion, very detailed requirements",                             result: "Engaged",                           next_step: "Send technical spec",      next_date: "2026-03-27", date: "2026-03-24", by: "Demo User" },
      { type: "Follow-up",        company: "Orion Fintech",        contact: "Lucas Ferreira",  notes: "Third touch. Lucas confirmed he's the decision maker. Moving fast.",               result: "Scheduled strategy call",           next_step: "Strategy call",            next_date: "2026-03-28", date: "2026-03-15", by: "Jordan Mitchell" }
    ]
  end
end
