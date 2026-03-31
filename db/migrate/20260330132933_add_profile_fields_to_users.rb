class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :full_name,     :string
    add_column :users, :team,          :string
    add_column :users, :active_status, :boolean, default: true, null: false
    add_column :users, :hire_date,     :date
  end
end
