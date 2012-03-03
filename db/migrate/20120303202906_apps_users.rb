class AppsUsers < ActiveRecord::Migration
  def change
    create_table :apps_users, :id => false do |t|
      t.integer :app_id
      t.integer :user_id
    end
    add_index :apps_users, :app_id
    add_index :apps_users, :user_id
    add_index :apps_users, [:app_id, :user_id], :unique => true
  end
end
