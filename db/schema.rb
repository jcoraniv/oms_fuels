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

ActiveRecord::Schema[8.0].define(version: 2026_01_24_074251) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "personal_id", null: false
    t.bigint "org_position_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_position_id"], name: "index_assignments_on_org_position_id"
    t.index ["personal_id"], name: "index_assignments_on_personal_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fuel_order_items", force: :cascade do |t|
    t.bigint "fuel_order_id", null: false
    t.decimal "quantity_ordered", precision: 10, scale: 2, null: false
    t.decimal "quantity_received", precision: 10, scale: 2
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.decimal "partial_price", precision: 12, scale: 2
    t.decimal "received_price", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "fuel_id", null: false
    t.bigint "vehicle_id"
    t.index ["fuel_id"], name: "index_fuel_order_items_on_fuel_id"
    t.index ["fuel_order_id"], name: "index_fuel_order_items_on_fuel_order_id"
    t.index ["vehicle_id"], name: "index_fuel_order_items_on_vehicle_id"
  end

  create_table "fuel_orders", force: :cascade do |t|
    t.string "number", null: false
    t.bigint "gestion_id", null: false
    t.bigint "requester_assignment_id", null: false
    t.bigint "approver_assignment_id"
    t.decimal "total", precision: 12, scale: 2, default: "0.0"
    t.string "status", default: "pending", null: false
    t.datetime "approved_at"
    t.datetime "completed_at"
    t.datetime "canceled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approver_assignment_id"], name: "index_fuel_orders_on_approver_assignment_id"
    t.index ["gestion_id"], name: "index_fuel_orders_on_gestion_id"
    t.index ["number"], name: "index_fuel_orders_on_number", unique: true
    t.index ["requester_assignment_id"], name: "index_fuel_orders_on_requester_assignment_id"
    t.index ["status"], name: "index_fuel_orders_on_status"
  end

  create_table "fuels", force: :cascade do |t|
    t.string "description"
    t.string "unit_of_measure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gestions", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_gestions_on_code", unique: true
  end

  create_table "org_positions", force: :cascade do |t|
    t.bigint "org_structure_id", null: false
    t.bigint "position_id", null: false
    t.bigint "reports_to_position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_structure_id"], name: "index_org_positions_on_org_structure_id"
    t.index ["position_id"], name: "index_org_positions_on_position_id"
    t.index ["reports_to_position_id"], name: "index_org_positions_on_reports_to_position_id"
  end

  create_table "org_structures", force: :cascade do |t|
    t.bigint "gestion_id", null: false
    t.bigint "department_id", null: false
    t.bigint "parent_dept_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_org_structures_on_department_id"
    t.index ["gestion_id"], name: "index_org_structures_on_gestion_id"
    t.index ["parent_dept_id"], name: "index_org_structures_on_parent_dept_id"
  end

  create_table "personals", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email"
    t.string "phone"
    t.string "ci", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "profession_id"
    t.index ["ci"], name: "index_personals_on_ci", unique: true
    t.index ["email"], name: "index_personals_on_email"
    t.index ["profession_id"], name: "index_personals_on_profession_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["code"], name: "index_positions_on_code", unique: true
  end

  create_table "professions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_professions_on_name", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "user_gestions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "gestion_id", null: false
    t.boolean "current", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gestion_id"], name: "index_user_gestions_on_gestion_id"
    t.index ["user_id", "gestion_id"], name: "index_user_gestions_on_user_id_and_gestion_id", unique: true
    t.index ["user_id"], name: "index_user_gestions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role_id", null: false
    t.integer "personal_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["personal_id"], name: "index_users_on_personal_id"
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "vehicle_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "plate"
    t.text "description"
    t.text "details"
    t.bigint "vehicle_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["vehicle_type_id"], name: "index_vehicles_on_vehicle_type_id"
  end

  add_foreign_key "assignments", "org_positions"
  add_foreign_key "assignments", "personals"
  add_foreign_key "fuel_order_items", "fuel_orders"
  add_foreign_key "fuel_order_items", "fuels"
  add_foreign_key "fuel_order_items", "vehicles"
  add_foreign_key "fuel_orders", "assignments", column: "approver_assignment_id"
  add_foreign_key "fuel_orders", "assignments", column: "requester_assignment_id"
  add_foreign_key "fuel_orders", "gestions"
  add_foreign_key "org_positions", "org_positions", column: "reports_to_position_id"
  add_foreign_key "org_positions", "org_structures"
  add_foreign_key "org_positions", "positions"
  add_foreign_key "org_structures", "departments"
  add_foreign_key "org_structures", "gestions"
  add_foreign_key "org_structures", "org_structures", column: "parent_dept_id"
  add_foreign_key "personals", "professions"
  add_foreign_key "user_gestions", "gestions"
  add_foreign_key "user_gestions", "users"
  add_foreign_key "users", "personals"
  add_foreign_key "users", "roles"
  add_foreign_key "vehicles", "vehicle_types"
end
