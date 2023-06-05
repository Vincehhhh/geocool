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

ActiveRecord::Schema[7.0].define(version: 2023_06_05_132712) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.integer "floor_area"
    t.string "type"
    t.integer "postal_code"
    t.string "city_name"
    t.string "category"
    t.integer "nominal_flow_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ground_types", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "thermal_conductivity"
    t.integer "density"
    t.integer "heat_capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string "social_name"
    t.string "address"
    t.string "admin_name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_manufacturers_on_user_id"
  end

  create_table "pipes", force: :cascade do |t|
    t.string "material"
    t.string "nominal_diameter_dn"
    t.string "name"
    t.bigint "manufacturer_id", null: false
    t.integer "thermal_conductivity"
    t.integer "thickness_mm"
    t.integer "diameter_ext_mm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manufacturer_id"], name: "index_pipes_on_manufacturer_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "building_id", null: false
    t.bigint "ground_type_id", null: false
    t.bigint "pipe_id", null: false
    t.date "start_heating_date"
    t.date "end_heating_date"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_projects_on_building_id"
    t.index ["ground_type_id"], name: "index_projects_on_ground_type_id"
    t.index ["pipe_id"], name: "index_projects_on_pipe_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "manufacturers", "users"
  add_foreign_key "pipes", "manufacturers"
  add_foreign_key "projects", "buildings"
  add_foreign_key "projects", "ground_types"
  add_foreign_key "projects", "pipes"
  add_foreign_key "projects", "users"
end
