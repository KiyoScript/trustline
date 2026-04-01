# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_31_055657) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "activities", force: :cascade do |t|
    t.date "activity_date", null: false
    t.integer "activity_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.bigint "lead_id", null: false
    t.string "next_step"
    t.date "next_step_date"
    t.text "notes"
    t.string "result"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["activity_date"], name: "index_activities_on_activity_date"
    t.index ["activity_type"], name: "index_activities_on_activity_type"
    t.index ["lead_id", "activity_date"], name: "index_activities_on_lead_id_and_activity_date"
    t.index ["lead_id"], name: "index_activities_on_lead_id"
    t.index ["user_id", "activity_date"], name: "index_activities_on_user_id_and_activity_date"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "lead_movement_histories", force: :cascade do |t|
    t.integer "action_type", default: 0, null: false
    t.bigint "changed_by_id", null: false
    t.datetime "created_at", null: false
    t.bigint "lead_id", null: false
    t.integer "month"
    t.text "movement_note"
    t.integer "new_stage"
    t.integer "new_status"
    t.integer "previous_stage"
    t.integer "previous_status"
    t.integer "quarter"
    t.datetime "timestamp", null: false
    t.datetime "updated_at", null: false
    t.integer "week_number"
    t.integer "year"
    t.index ["action_type"], name: "index_lead_movement_histories_on_action_type"
    t.index ["changed_by_id"], name: "index_lead_movement_histories_on_changed_by_id"
    t.index ["lead_id", "timestamp"], name: "index_lead_movement_histories_on_lead_id_and_timestamp"
    t.index ["lead_id"], name: "index_lead_movement_histories_on_lead_id"
    t.index ["week_number"], name: "index_lead_movement_histories_on_week_number"
  end

  create_table "leads", force: :cascade do |t|
    t.bigint "assigned_to_id"
    t.string "company_name", null: false
    t.string "contact_name", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.date "date_added"
    t.date "date_removed"
    t.string "email"
    t.string "industry"
    t.string "job_title"
    t.date "last_contact_date"
    t.bigint "last_updated_by_id"
    t.decimal "lead_value_estimate", precision: 12, scale: 2
    t.text "next_action"
    t.date "next_action_date"
    t.text "notes"
    t.bigint "owner_id", null: false
    t.string "phone"
    t.string "removal_reason"
    t.integer "source", default: 0, null: false
    t.integer "stage", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "tags", default: [], array: true
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_leads_on_assigned_to_id"
    t.index ["created_by_id"], name: "index_leads_on_created_by_id"
    t.index ["date_added"], name: "index_leads_on_date_added"
    t.index ["last_updated_by_id"], name: "index_leads_on_last_updated_by_id"
    t.index ["next_action_date"], name: "index_leads_on_next_action_date"
    t.index ["owner_id"], name: "index_leads_on_owner_id"
    t.index ["source"], name: "index_leads_on_source"
    t.index ["stage"], name: "index_leads_on_stage"
    t.index ["status"], name: "index_leads_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active_status", default: true, null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.date "hire_date"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.string "team"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "leads"
  add_foreign_key "activities", "users"
  add_foreign_key "lead_movement_histories", "leads"
  add_foreign_key "lead_movement_histories", "users", column: "changed_by_id"
  add_foreign_key "leads", "users", column: "assigned_to_id"
  add_foreign_key "leads", "users", column: "created_by_id"
  add_foreign_key "leads", "users", column: "last_updated_by_id"
  add_foreign_key "leads", "users", column: "owner_id"
end
