# app/controllers/dashboard/teams_controller.rb
class Dashboard::TeamsController < ApplicationController
  before_action :authenticate_user!

  def index
    @members = static_members
  end

  private

  def static_members
    [
      { name: "Demo User",       email: "demo@trustline.com",          role: "admin",   status: "active", leads: 6,  activities: 10, won: 1, joined: "2026-01-15" },
      { name: "Jordan Mitchell", email: "jordan.mitchell@trustline.com", role: "manager", status: "active", leads: 5,  activities: 4,  won: 1, joined: "2026-01-20" },
      { name: "Taylor Brooks",   email: "taylor.brooks@trustline.com",   role: "manager", status: "active", leads: 4,  activities: 4,  won: 0, joined: "2026-02-01" },
      { name: "Cymon Trillana",  email: "cymon.t@trustline.com",         role: "agent",   status: "active", leads: 3,  activities: 1,  won: 0, joined: "2026-02-10" },
      { name: "Alex Rivera",     email: "alex.rivera@trustline.com",     role: "agent",   status: "active", leads: 2,  activities: 1,  won: 0, joined: "2026-02-15" },
      { name: "Casey Nguyen",    email: "casey.nguyen@trustline.com",    role: "agent",   status: "active", leads: 1,  activities: 1,  won: 0, joined: "2026-03-01" },
      { name: "Ken Enecio",      email: "ken.enecio@trustline.com",      role: "viewer",  status: "active", leads: 0,  activities: 0,  won: 0, joined: "2026-03-10" }
    ]
  end
end
