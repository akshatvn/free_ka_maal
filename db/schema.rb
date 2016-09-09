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

ActiveRecord::Schema.define(version: 20160909140555) do

  create_table "clients", force: :cascade do |t|
    t.binary   "user_id",    limit: 16
    t.string   "auth_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_transactions", force: :cascade do |t|
    t.binary   "user_id",     limit: 16
    t.string   "amount",      limit: 255
    t.binary   "source_id",   limit: 16
    t.string   "source_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_ads", force: :cascade do |t|
    t.binary   "user_id",    limit: 16
    t.string   "type",       limit: 255, null: false
    t.integer  "status_cd",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_events", force: :cascade do |t|
    t.binary   "user_id",    limit: 16
    t.string   "code",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.binary   "user_id",    limit: 16
    t.string   "code",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",          limit: 255, null: false
    t.integer  "credit_balance", limit: 4
    t.datetime "last_synced"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth_uid",      limit: 255
    t.string   "oauth_provider", limit: 20
  end

end
