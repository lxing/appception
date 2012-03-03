class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, :unique => :true
      t.integer :fb_id, :unique => :true
      t.timestamps
    end
    add_index :users, :name
    add_index :users, :email
    add_index :users, :fb_id
  end
end
