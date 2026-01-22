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

ActiveRecord::Schema[8.0].define(version: 2025_01_01_000010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.integer "level", null: false
    t.integer "parent_id"
    t.integer "gestion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gestion_id"], name: "index_departments_on_gestion_id"
    t.index ["parent_id"], name: "index_departments_on_parent_id"
  end

  create_table "gestions", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_gestions_on_code", unique: true
  end

  create_table "personal_positions", force: :cascade do |t|
    t.integer "personal_id", null: false
    t.integer "position_id", null: false
    t.integer "gestion_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gestion_id"], name: "index_personal_positions_on_gestion_id"
    t.index ["personal_id"], name: "index_personal_positions_on_personal_id"
    t.index ["position_id"], name: "index_personal_positions_on_position_id"
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
    t.integer "department_id", null: false
    t.integer "gestion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_positions_on_department_id"
    t.index ["gestion_id"], name: "index_positions_on_gestion_id"
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

  add_foreign_key "departments", "departments", column: "parent_id"
  add_foreign_key "departments", "gestions"
  add_foreign_key "personal_positions", "gestions"
  add_foreign_key "personal_positions", "personals"
  add_foreign_key "personal_positions", "positions"
  add_foreign_key "personals", "professions"
  add_foreign_key "positions", "departments"
  add_foreign_key "positions", "gestions"
  add_foreign_key "user_gestions", "gestions"
  add_foreign_key "user_gestions", "users"
  add_foreign_key "users", "personals"
  add_foreign_key "users", "roles"
end
