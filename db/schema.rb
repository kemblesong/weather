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

ActiveRecord::Schema.define(version: 20150423115549) do

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.float  "latitude"
    t.float  "longitude"
  end

  create_table "observations", force: :cascade do |t|
    t.float   "temperature"
    t.float   "dew_point"
    t.float   "rainfall"
    t.string  "wind_direction"
    t.float   "wind_speed"
    t.integer "source_id"
    t.integer "location_id"
    t.integer "time_stamp_id"
  end

  add_index "observations", ["location_id"], name: "index_observations_on_location_id"
  add_index "observations", ["source_id"], name: "index_observations_on_source_id"
  add_index "observations", ["time_stamp_id"], name: "index_observations_on_time_stamp_id"

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "format"
  end

  create_table "time_stamps", force: :cascade do |t|
    t.integer "timestamp"
  end

end
