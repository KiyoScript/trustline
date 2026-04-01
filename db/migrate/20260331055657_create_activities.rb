class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.references :lead,          null: false, foreign_key: true
      t.references :user,          null: false, foreign_key: true
      t.integer    :activity_type, null: false, default: 0   # enum
      t.date       :activity_date, null: false
      t.string     :result
      t.text       :notes
      t.string     :next_step
      t.date       :next_step_date

      t.timestamps
    end

    add_index :activities, :activity_type
    add_index :activities, :activity_date
    add_index :activities, [ :lead_id, :activity_date ]
    add_index :activities, [ :user_id, :activity_date ]
  end
end
