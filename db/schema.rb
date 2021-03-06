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

ActiveRecord::Schema.define(version: 20150525052355) do

  create_table "locations", force: :cascade do |t|
    t.string  "name"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "postcode"
  end

  create_table "measurements", force: :cascade do |t|
    t.float "temperature"
    t.float "rainfall"
    t.float "wind_direction"
    t.float "wind_speed"
  end

  create_table "observations", force: :cascade do |t|
    t.integer "observed_at"
    t.integer "location_id"
    t.integer "measurement_id"
  end

  add_index "observations", ["location_id"], name: "index_observations_on_location_id"
  add_index "observations", ["measurement_id"], name: "index_observations_on_measurement_id"

  create_table "predictions", force: :cascade do |t|
    t.integer "predicted_at"
    t.integer "time_since_query"
    t.float   "rainfall_prob"
    t.float   "temp_prob"
    t.float   "wind_dir_prob"
    t.float   "wind_speed_prob"
  end

end
