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

ActiveRecord::Schema.define(version: 20170109061655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clubs", id: :integer, limit: 2, force: :cascade do |t|
    t.text "name", null: false
  end

  create_table "levels", id: :integer, limit: 2, force: :cascade do |t|
    t.text "name", null: false
  end

  create_table "persons", id: :bigserial, force: :cascade do |t|
    t.integer "age",         limit: 2, null: false
    t.integer "rank",        limit: 2, null: false
    t.boolean "sex",                   null: false
    t.text    "first_name",            null: false
    t.text    "last_name",             null: false
    t.text    "middle_name",           null: false
    t.integer "club_id",     limit: 2, null: false
    t.integer "level_id",    limit: 2, null: false
    t.index ["club_id"], name: "persons_7115697a", using: :btree
    t.index ["level_id"], name: "persons_80e0bd5f", using: :btree
  end

  create_table "statuses", force: :cascade do |t|
    t.text "name", null: false
  end

  create_table "tournament_persons", id: :bigserial, force: :cascade do |t|
    t.bigint "tournament_id"
    t.bigint "person_id"
  end

  create_table "tournament_types", force: :cascade do |t|
    t.text "name", null: false
  end

  create_table "tournaments", id: :bigserial, force: :cascade do |t|
    t.text     "full_name",          null: false
    t.text     "short_name",         null: false
    t.integer  "status_id",          null: false
    t.integer  "tournament_type_id", null: false
    t.datetime "end_date",           null: false
    t.datetime "start_date",         null: false
    t.index ["status_id"], name: "tournaments_status_id_394b6e5b_uniq", using: :btree
    t.index ["tournament_type_id"], name: "tournaments_94757cae", using: :btree
  end

  add_foreign_key "persons", "clubs", name: "persons_club_id_45ef2623_fk_clubs_id"
  add_foreign_key "persons", "levels", name: "persons_level_id_29e16dbf_fk_levels_id"
  add_foreign_key "tournaments", "statuses", name: "tournaments_status_id_394b6e5b_fk_statuses_id"
  add_foreign_key "tournaments", "tournament_types", name: "tournaments_type_id_4b563153_fk_tournament_types_id"
end
