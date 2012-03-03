# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120303202906) do

  create_table "apps", :force => true do |t|
    t.string   "google_id"
    t.string   "name"
    t.string   "icon"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["google_id"], :name => "index_apps_on_google_id"
  add_index "apps", ["name"], :name => "index_apps_on_name"

  create_table "apps_users", :id => false, :force => true do |t|
    t.integer "app_id"
    t.integer "user_id"
  end

  add_index "apps_users", ["app_id", "user_id"], :name => "index_apps_users_on_app_id_and_user_id", :unique => true
  add_index "apps_users", ["app_id"], :name => "index_apps_users_on_app_id"
  add_index "apps_users", ["user_id"], :name => "index_apps_users_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "fb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["fb_id"], :name => "index_users_on_fb_id"
  add_index "users", ["name"], :name => "index_users_on_name"

end
