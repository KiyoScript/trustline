# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

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
puts "Done! You can log in with demo@trustline.com / password123"
