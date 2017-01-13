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

ActiveRecord::Schema.define(version: 20170111131613) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clubs", id: :integer, limit: 2, force: :cascade do |t|
    t.text "name", null: false
  end

  create_table "levels", id: :integer, limit: 2, force: :cascade do |t|
    t.text "name", null: false
  end

  create_table "persons", id: :bigserial, force: :cascade do |t|
    t.integer "rank",        limit: 2
    t.boolean "sex",                     null: false
    t.text    "first_name",              null: false
    t.text    "last_name",               null: false
    t.text    "middle_name"
    t.integer "club_id",     limit: 2,   null: false
    t.integer "level_id",    limit: 2,   null: false
    t.date    "birth_date"
    t.string  "phone",       limit: 15
    t.string  "email",       limit: 255
    t.index ["club_id"], name: "persons_7115697a", using: :btree
    t.index ["level_id"], name: "persons_80e0bd5f", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "statuses", force: :cascade do |t|
    t.text "name", null: false
  end

  create_table "tournament_persons", id: :bigserial, force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.bigint "person_id",     null: false
    t.index ["person_id"], name: "fki_person_fk", using: :btree
    t.index ["tournament_id"], name: "fki_tournament_fk", using: :btree
  end

  create_table "tournament_types", force: :cascade do |t|
    t.text "name", null: false
  end

  create_table "tournaments", id: :bigserial, force: :cascade do |t|
    t.text     "full_name",                       null: false
    t.text     "short_name",                      null: false
    t.integer  "status_id",                       null: false
    t.integer  "tournament_type_id",              null: false
    t.datetime "end_date",                        null: false
    t.datetime "start_date",                      null: false
    t.string   "image_link",         limit: 1024
    t.string   "place",              limit: 1024
    t.index ["status_id"], name: "tournaments_status_id_394b6e5b_uniq", using: :btree
    t.index ["tournament_type_id"], name: "tournaments_94757cae", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  add_foreign_key "persons", "clubs", name: "persons_club_id_45ef2623_fk_clubs_id"
  add_foreign_key "persons", "levels", name: "persons_level_id_29e16dbf_fk_levels_id"
  add_foreign_key "tournament_persons", "persons", name: "person_fk"
  add_foreign_key "tournament_persons", "tournaments", name: "tournament_fk"
  add_foreign_key "tournaments", "statuses", name: "tournaments_status_id_394b6e5b_fk_statuses_id"
  add_foreign_key "tournaments", "tournament_types", name: "tournaments_type_id_4b563153_fk_tournament_types_id"
end
