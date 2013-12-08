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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131208104413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_providers", force: true do |t|
    t.string   "key",        null: false
    t.string   "name",       null: false
    t.string   "token"
    t.string   "user_id"
    t.string   "user_name"
    t.datetime "synced_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auth_providers", ["key"], name: "index_auth_providers_on_key", unique: true, using: :btree

  create_table "contact_messages", force: true do |t|
    t.string   "email",      null: false
    t.string   "name",       null: false
    t.text     "message",    null: false
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", force: true do |t|
    t.string   "name",                      null: false
    t.string   "email",                     null: false
    t.boolean  "enabled",    default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribers", ["email"], name: "index_subscribers_on_email", unique: true, using: :btree

end
