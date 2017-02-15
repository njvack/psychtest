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

ActiveRecord::Schema.define(version: 20170206163556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessments", force: :cascade do |t|
    t.string   "user_agent"
    t.boolean  "completed",     default: false, null: false
    t.jsonb    "configuration"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "assessment_id"
    t.integer  "unique_id",          null: false
    t.float    "relative_timestamp", null: false
    t.jsonb    "event_json",         null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["assessment_id", "unique_id"], name: "index_events_on_assessment_id_and_unique_id", unique: true, using: :btree
    t.index ["assessment_id"], name: "index_events_on_assessment_id", using: :btree
    t.index ["event_json"], name: "index_events_on_event_json", using: :gin
  end

  create_table "measurements", force: :cascade do |t|
    t.integer  "assessment_id"
    t.integer  "unique_id",     null: false
    t.string   "category",      null: false
    t.float    "value",         null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["assessment_id", "unique_id"], name: "index_measurements_on_assessment_id_and_unique_id", unique: true, using: :btree
    t.index ["assessment_id"], name: "index_measurements_on_assessment_id", using: :btree
  end

end
