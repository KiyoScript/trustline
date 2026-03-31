class CreateLeadMovementHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :lead_movement_histories do |t|
      t.references :lead,           null: false, foreign_key: true
      t.references :changed_by,     null: false, foreign_key: { to_table: :users }
      t.integer    :previous_stage
      t.integer    :new_stage
      t.integer    :previous_status
      t.integer    :new_status
      t.integer    :action_type,    null: false, default: 0  # enum
      t.text       :movement_note
      t.datetime   :timestamp,      null: false
      t.integer    :week_number
      t.integer    :month
      t.integer    :quarter
      t.integer    :year

      t.timestamps
    end

    add_index :lead_movement_histories, :action_type
    add_index :lead_movement_histories, :week_number
    add_index :lead_movement_histories, [ :lead_id, :timestamp ]
  end
end
