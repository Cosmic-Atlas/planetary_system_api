# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_01_11_162254) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "moons", force: :cascade do |t|
    t.string "name"
    t.bigint "radius_km"
    t.float "rotational_period"
    t.float "magnitude"
    t.bigint "planet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planet_id"], name: "index_moons_on_planet_id"
  end

  create_table "planetary_systems", force: :cascade do |t|
    t.string "name"
    t.integer "light_years_from_earth"
    t.bigint "star_age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "planets", force: :cascade do |t|
    t.string "name"
    t.string "planet_type"
    t.integer "year_discovered"
    t.boolean "confirmed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "planetary_system_id"
    t.index ["planetary_system_id"], name: "index_planets_on_planetary_system_id"
  end

  add_foreign_key "moons", "planets"
  add_foreign_key "planets", "planetary_systems"
end
