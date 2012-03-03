class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :google_id, :unique => true
      t.string :name
      t.string :icon
      t.text :description
      t.timestamps
    end

    add_index :apps, :google_id
    add_index :apps, :name
  end
end
