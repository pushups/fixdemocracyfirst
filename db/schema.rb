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

ActiveRecord::Schema.define(version: 20150330014434) do

  create_table "attendees", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "event_day_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.integer  "rwu_id",       limit: 4
    t.integer  "candidate_id", limit: 4
    t.integer  "election_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "candidates", force: :cascade do |t|
    t.integer  "rwu_id",     limit: 4
    t.integer  "person_id",  limit: 4
    t.string   "office_id",  limit: 255
    t.string   "position",   limit: 255
    t.string   "district",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "candidates_events", id: false, force: :cascade do |t|
    t.integer "candidate_id", limit: 4, null: false
    t.integer "event_id",     limit: 4, null: false
  end

  add_index "candidates_events", ["candidate_id", "event_id"], name: "index_candidates_events_on_candidate_id_and_event_id", using: :btree
  add_index "candidates_events", ["event_id", "candidate_id"], name: "index_candidates_events_on_event_id_and_candidate_id", using: :btree

  create_table "elections", force: :cascade do |t|
    t.integer  "rwu_id",         limit: 4
    t.string   "name",           limit: 255
    t.integer  "election_id",    limit: 4
    t.string   "state",          limit: 255
    t.string   "office_type_id", limit: 255
    t.boolean  "special",        limit: 1
    t.integer  "election_year",  limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "event_days", force: :cascade do |t|
    t.integer  "rwu_id",     limit: 4
    t.integer  "event_id",   limit: 4
    t.datetime "date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "rwu_id",      limit: 4
    t.string   "title",       limit: 255
    t.string   "description", limit: 255
    t.integer  "venue_id",    limit: 4
    t.boolean  "public",      limit: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "people", force: :cascade do |t|
    t.integer  "rwu_id",      limit: 4
    t.string   "first_name",  limit: 255
    t.string   "nickname",    limit: 255
    t.string   "middle_name", limit: 255
    t.string   "last_name",   limit: 255
    t.string   "suffix",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "statements", force: :cascade do |t|
    t.integer  "rwu_id",       limit: 4
    t.integer  "user_id",      limit: 4
    t.integer  "event_day_id", limit: 4
    t.integer  "campaign_id",  limit: 4
    t.integer  "candidate_id", limit: 4
    t.string   "title",        limit: 255
    t.string   "url",          limit: 255
    t.string   "description",  limit: 255
    t.boolean  "approved",     limit: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "fullname",   limit: 255
    t.string   "email",      limit: 255
    t.string   "location",   limit: 255
    t.string   "fb_uid",     limit: 255
    t.string   "fb_token",   limit: 255
    t.boolean  "admin",      limit: 1,   default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["fb_uid"], name: "index_users_on_fb_uid", using: :btree

  create_table "venues", force: :cascade do |t|
    t.integer  "rwu_id",          limit: 4
    t.string   "name",            limit: 255
    t.string   "street_address1", limit: 255
    t.string   "street_address2", limit: 255
    t.string   "unit",            limit: 255
    t.string   "city",            limit: 255
    t.string   "state",           limit: 255
    t.string   "postal_code",     limit: 255
    t.string   "url",             limit: 255
    t.float    "latitude",        limit: 24
    t.float    "longitude",       limit: 24
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

end
