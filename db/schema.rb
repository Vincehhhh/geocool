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

ActiveRecord::Schema[7.0].define(version: 2023_06_08_124251) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.integer "area"
    t.string "building_type"
    t.integer "postal_code"
    t.string "city_name"
    t.string "category"
    t.integer "nominal_flow_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "energetic_results", force: :cascade do |t|
    t.bigint "energetic_study_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["energetic_study_id"], name: "index_energetic_results_on_energetic_study_id"
  end

  create_table "energetic_studies", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.date "start_heating_date"
    t.date "end_heating_date"
    t.integer "studied_length"
    t.integer "number_of_branches"
    t.integer "underground_depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_energetic_studies_on_project_id"
  end

  create_table "ground_types", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "lambda_ground"
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
    t.integer "diameter_int"
    t.index ["manufacturer_id"], name: "index_pipes_on_manufacturer_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "building_id", null: false
    t.bigint "ground_type_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_projects_on_building_id"
    t.index ["ground_type_id"], name: "index_projects_on_ground_type_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "studied_pipes", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "pipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipe_id"], name: "index_studied_pipes_on_pipe_id"
    t.index ["project_id"], name: "index_studied_pipes_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_name"
    t.boolean "premium_status"
    t.string "occupation"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "working_pipes", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "pipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipe_id"], name: "index_working_pipes_on_pipe_id"
    t.index ["project_id"], name: "index_working_pipes_on_project_id"
  end

  create_table "working_well_systems", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "working_pipe_id", null: false
    t.integer "proposed_length_lo"
    t.integer "proposed_number_of_pipes"
    t.integer "occupied_area"
    t.integer "proposed_total_length"
    t.integer "nominal_speed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_working_well_systems_on_project_id"
    t.index ["working_pipe_id"], name: "index_working_well_systems_on_working_pipe_id"
  end

  add_foreign_key "energetic_results", "energetic_studies"
  add_foreign_key "energetic_studies", "projects"
  add_foreign_key "manufacturers", "users"
  add_foreign_key "pipes", "manufacturers"
  add_foreign_key "projects", "buildings"
  add_foreign_key "projects", "ground_types"
  add_foreign_key "projects", "users"
  add_foreign_key "studied_pipes", "pipes"
  add_foreign_key "studied_pipes", "projects"
  add_foreign_key "working_pipes", "pipes"
  add_foreign_key "working_pipes", "projects"
  add_foreign_key "working_well_systems", "projects"
  add_foreign_key "working_well_systems", "working_pipes"
end
