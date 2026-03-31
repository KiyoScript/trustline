class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      t.string   :company_name,       null: false
      t.string   :contact_name,       null: false
      t.string   :job_title
      t.string   :email
      t.string   :phone
      t.integer  :source,             default: 0, null: false   # enum
      t.string   :industry
      t.references :assigned_to,      null: true,  foreign_key: { to_table: :users }
      t.references :owner,            null: false, foreign_key: { to_table: :users }
      t.integer  :stage,              default: 0, null: false   # enum
      t.integer  :status,             default: 0, null: false   # enum: active, won, lost, removed
      t.decimal  :lead_value_estimate, precision: 12, scale: 2
      t.date     :date_added
      t.date     :date_removed
      t.string   :removal_reason
      t.date     :last_contact_date
      t.text     :next_action
      t.date     :next_action_date
      t.text     :notes
      t.string   :tags,               array: true, default: []
      t.references :created_by,       null: false, foreign_key: { to_table: :users }
      t.references :last_updated_by,  null: true,  foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :leads, :stage
    add_index :leads, :status
    add_index :leads, :source
    add_index :leads, :next_action_date
    add_index :leads, :date_added
  end
end
