# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
puts "Seeding demo data..."

# ── Users ──────────────────────────────────────────────────────────────────────
users = {}

[
  { full_name: "Demo User",       email: "demo@trustline.com",           role: :admin,   team: "Sales" },
  { full_name: "Jordan Mitchell", email: "jordan.mitchell@trustline.com", role: :manager, team: "Sales" },
  { full_name: "Taylor Brooks",   email: "taylor.brooks@trustline.com",   role: :manager, team: "BD" },
  { full_name: "Cymon Trillana",  email: "cymon.t@trustline.com",         role: :agent,   team: "Sales" },
  { full_name: "Alex Rivera",     email: "alex.rivera@trustline.com",     role: :agent,   team: "BD" },
  { full_name: "Casey Nguyen",    email: "casey.nguyen@trustline.com",    role: :agent,   team: "Sales" },
  { full_name: "Ken Enecio",      email: "ken.enecio@trustline.com",      role: :viewer,  team: "Exec" }
].each do |attrs|
  user = User.find_or_create_by!(email: attrs[:email]) do |u|
    u.full_name     = attrs[:full_name]
    u.role          = attrs[:role]
    u.team          = attrs[:team]
    u.password      = "password123"
    u.active_status = true
    u.hire_date     = 2.months.ago.to_date
  end
  users[attrs[:full_name]] = user
end

puts "  Created #{users.size} users"

# ── Leads ───────────────────────────────────────────────────────────────────────
demo     = users["Demo User"]
jordan   = users["Jordan Mitchell"]
taylor   = users["Taylor Brooks"]
cymon    = users["Cymon Trillana"]
alex     = users["Alex Rivera"]
casey    = users["Casey Nguyen"]

leads_data = [
  { company: "Pinnacle Health",      contact: "Dr. Laura Kim",   source: :website,  stage: :call_booked,           owner: demo,   assigned: demo,   next_date: "2026-03-18", last_contact: "2026-03-10" },
  { company: "ClearPath Logistics",  contact: "Ahmed Suleiman",  source: :linkedin, stage: :contacted,             owner: demo,   assigned: cymon,  next_date: "2026-03-27", last_contact: "2026-03-20" },
  { company: "Apex Retail Group",    contact: "Michelle Torres", source: :referral, stage: :proposal_sent,         owner: taylor, assigned: taylor, next_date: "2026-03-24", last_contact: "2026-03-15" },
  { company: "CloudEdge Systems",    contact: "Patrick Wu",      source: :linkedin, stage: :engaged,               owner: demo,   assigned: alex,   next_date: "2026-03-25", last_contact: "2026-03-18" },
  { company: "Harborview Legal",     contact: "Rachel Stone",    source: :apollo,   stage: :sourced,               owner: demo,   assigned: demo,   next_date: "2026-03-26", last_contact: "2026-03-12" },
  { company: "Skyline Developments", contact: "Daniel Brooks",   source: :manual,   stage: :proposal_sent,         owner: taylor, assigned: taylor, next_date: "2026-03-19", last_contact: "2026-03-10" },
  { company: "Vantage Pharma",       contact: "Grace Huang",     source: :apollo,   stage: :engaged,               owner: jordan, assigned: jordan, next_date: "2026-03-23", last_contact: "2026-03-14" },
  { company: "Orion Fintech",        contact: "Lucas Ferreira",  source: :linkedin, stage: :qualified,             owner: demo,   assigned: demo,   next_date: "2026-03-28", last_contact: "2026-03-22" },
  { company: "Summit Education",     contact: "Oliver Hayes",    source: :website,  stage: :call_booked,           owner: jordan, assigned: jordan, next_date: "2026-03-27", last_contact: "2026-03-20" },
  { company: "Acme Corp",            contact: "John Martinez",   source: :linkedin, stage: :qualified,             owner: demo,   assigned: demo,   next_date: "2026-03-26", last_contact: "2026-03-19" },
  { company: "TechFlow Inc",         contact: "Sarah Chen",      source: :apollo,   stage: :discovery_done,        owner: demo,   assigned: cymon,  next_date: "2026-03-27", last_contact: "2026-03-21" },
  { company: "Global Media",         contact: "David Kim",       source: :referral, stage: :proposal_sent,         owner: demo,   assigned: demo,   next_date: "2026-03-25", last_contact: "2026-03-16" },
  { company: "NovaTech",             contact: "Lisa Wang",       source: :website,  stage: :contacted,             owner: taylor, assigned: taylor, next_date: "2026-03-28", last_contact: "2026-03-18" },
  { company: "Bright Solutions",     contact: "Mike O'Brien",    source: :linkedin, stage: :engaged,               owner: demo,   assigned: alex,   next_date: "2026-03-26", last_contact: "2026-03-17" },
  { company: "Quantum Labs",         contact: "Dr. Amy Foster",  source: :manual,   stage: :sourced,               owner: casey,  assigned: casey,  next_date: "2026-03-26", last_contact: "2026-03-10" },
  { company: "OmniHealth",           contact: "Dr. Patel",       source: :referral, stage: :sourced,               owner: demo,   assigned: demo,   next_date: "2026-03-28", last_contact: "2026-03-08" },
  { company: "EduPlatform",          contact: "Maria Santos",    source: :linkedin, stage: :contacted,             owner: cymon,  assigned: cymon,  next_date: "2026-03-20", last_contact: "2026-03-12" },
  { company: "CloudNine Systems",    contact: "Alex Park",       source: :website,  stage: :qualified,             owner: demo,   assigned: alex,   next_date: "2026-03-27", last_contact: "2026-03-20" },
  { company: "FinServe Partners",    contact: "Emily Turner",    source: :apollo,   stage: :call_booked,           owner: demo,   assigned: demo,   next_date: "2026-03-27", last_contact: "2026-03-21" },
  { company: "GreenPath Energy",     contact: "Tom Harris",      source: :referral, stage: :negotiation_follow_up, owner: jordan, assigned: jordan, next_date: "2026-03-28", last_contact: "2026-03-24" }
]

leads_data.each do |ld|
  lead = Lead.find_or_create_by!(company_name: ld[:company], contact_name: ld[:contact]) do |l|
    l.source              = ld[:source]
    l.stage               = ld[:stage]
    l.status              = :active
    l.owner               = ld[:owner]
    l.assigned_to         = ld[:assigned]
    l.created_by          = ld[:owner]
    l.last_updated_by     = ld[:owner]
    l.next_action_date    = ld[:next_date]
    l.last_contact_date   = ld[:last_contact]
    l.date_added          = 30.days.ago.to_date + rand(20).days
    l.next_action         = "Follow up"
  end

  # Seed initial movement history
  LeadMovementHistory.find_or_create_by!(
    lead:        lead,
    action_type: :created,
    timestamp:   lead.created_at
  ) do |m|
    m.changed_by    = ld[:owner]
    m.new_stage     = Lead.stages[ld[:stage].to_s]
    m.new_status    = Lead.statuses["active"]
    m.movement_note = "Lead created"
    m.week_number   = lead.created_at.to_date.cweek
    m.month         = lead.created_at.month
    m.quarter       = (lead.created_at.month / 3.0).ceil
    m.year          = lead.created_at.year
  end
end

puts "  Created #{leads_data.size} leads"

# ── Activities ──────────────────────────────────────────────────────────────────
activities_data = [
  { lead: "GreenPath Energy",     user: demo,   type: :call,             date: "2026-03-24", result: "In Progress",                  notes: "Reviewing final contract terms, legal involved",                                     next_step: "Final contract review",    next_date: "2026-03-28" },
  { lead: "Acme Corp",            user: demo,   type: :call,             date: "2026-03-22", result: "Positive",                     notes: "Discussed enterprise pricing, very interested",                                      next_step: "Send proposal",            next_date: "2026-03-26" },
  { lead: "FinServe Partners",    user: demo,   type: :call,             date: "2026-03-19", result: "Interested",                   notes: "Brief intro call, very interested in enterprise features",                          next_step: nil,                        next_date: nil },
  { lead: "Vantage Pharma",       user: jordan, type: :call,             date: "2026-03-18", result: "Very positive — CTO engaged",  notes: "Discussed technical requirements. Full API integration needed. Budget approved Q2.", next_step: "Send formal proposal",     next_date: "2026-03-20" },
  { lead: "Pinnacle Health",      user: demo,   type: :call,             date: "2026-03-16", result: "Interested in full platform",  notes: "Compliance-heavy environment. Need to emphasize security certifications.",           next_step: "Send case studies",        next_date: "2026-03-23" },
  { lead: "Summit Education",     user: demo,   type: :call,             date: "2026-03-14", result: "Needs demo",                   notes: "Discussed integration with existing LMS system",                                     next_step: "Schedule demo",            next_date: "2026-03-25" },
  { lead: "FinServe Partners",    user: demo,   type: :email,            date: "2026-03-23", result: "Confirmed",                    notes: "Confirmed discovery call for March 27",                                              next_step: "Discovery call",           next_date: "2026-03-27" },
  { lead: "NovaTech",             user: jordan, type: :email,            date: "2026-03-20", result: "Confirmed call date",          notes: "Sent calendar invite for Thursday 3pm. Lisa mentioned she'd loop in ops team.",      next_step: "Prep discovery agenda",    next_date: nil },
  { lead: "ClearPath Logistics",  user: demo,   type: :email,            date: "2026-03-19", result: "Initial contact made",         notes: "Sent intro email with product overview PDF. Ahmed opened it 3 times.",              next_step: "Follow up call",           next_date: "2026-03-27" },
  { lead: "Quantum Labs",         user: demo,   type: :email,            date: "2026-03-17", result: "Interested",                   notes: "Responded to inbound inquiry. Sent pricing tiers.",                                  next_step: "Book intro call",          next_date: "2026-03-26" },
  { lead: "Summit Education",     user: demo,   type: :email,            date: "2026-03-15", result: "Re-engaged",                   notes: "Followed up after no response. He replied same day.",                                next_step: "Call this week",           next_date: "2026-03-28" },
  { lead: "Apex Retail Group",    user: jordan, type: :email,            date: "2026-03-13", result: "Under review",                 notes: "Sent revised pricing proposal after negotiation.",                                   next_step: "Follow up",                next_date: "2026-03-29" },
  { lead: "Bright Solutions",     user: demo,   type: :linkedin_message, date: "2026-03-21", result: "Replied",                      notes: "Connected on LinkedIn, scheduling call.",                                             next_step: "Qualification call",       next_date: "2026-03-26" },
  { lead: "CloudEdge Systems",    user: alex,   type: :linkedin_message, date: "2026-03-17", result: "Responded positively",         notes: "Initial outreach on LinkedIn. Patrick confirmed interest and asked for product details.", next_step: "Schedule product demo", next_date: "2026-03-25" },
  { lead: "TechFlow Inc",         user: demo,   type: :meeting,          date: "2026-03-20", result: "Completed discovery",          notes: "Full technical requirements gathered, CTO aligned.",                                  next_step: "Schedule demo",            next_date: "2026-03-27" },
  { lead: "Orion Fintech",        user: taylor, type: :meeting,          date: "2026-03-15", result: "Strong interest, negotiation", notes: "In-person meeting. They want a 10% discount. Decision expected by end of month.",    next_step: "Revised proposal",         next_date: "2026-03-22" },
  { lead: "Global Media",         user: demo,   type: :proposal_sent,    date: "2026-03-18", result: "Sent",                         notes: "Custom proposal for 24-month plan.",                                                 next_step: "Follow up on proposal",    next_date: "2026-03-25" },
  { lead: "Skyline Developments", user: taylor, type: :proposal_sent,    date: "2026-03-10", result: "Proposal delivered — $95k",    notes: "Board reviewing on 21st. Price was accepted in principle.",                          next_step: "Negotiate contract terms", next_date: "2026-03-19" },
  { lead: "ClearPath Logistics",  user: cymon,  type: :follow_up,        date: "2026-03-27", result: "Voice mail",                   notes: "Client asked me to call today but got voice mail 7 times.",                          next_step: "Call again monday",        next_date: "2026-03-30" },
  { lead: "CloudNine Systems",    user: demo,   type: :follow_up,        date: "2026-03-24", result: "Engaged",                      notes: "Technical spec discussion, very detailed requirements.",                              next_step: "Send technical spec",      next_date: "2026-03-27" },
  { lead: "Orion Fintech",        user: jordan, type: :follow_up,        date: "2026-03-15", result: "Scheduled strategy call",      notes: "Third touch. Lucas confirmed he's the decision maker. Moving fast.",                  next_step: "Strategy call",            next_date: "2026-03-28" }
]

activities_data.each do |ad|
  lead = Lead.find_by!(company_name: ad[:lead])
  Activity.find_or_create_by!(
    lead:          lead,
    user:          ad[:user],
    activity_type: ad[:type],
    activity_date: ad[:date]
  ) do |a|
    a.result        = ad[:result]
    a.notes         = ad[:notes]
    a.next_step     = ad[:next_step]
    a.next_step_date = ad[:next_date]
  end
end

puts "  Created #{activities_data.size} activities"
puts "Done! You can log in with demo@trustline.com / password123"
