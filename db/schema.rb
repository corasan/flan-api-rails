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

ActiveRecord::Schema.define(version: 2022_01_06_163704) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "expenses", force: :cascade do |t|
    t.string "name"
    t.decimal "amount"
    t.string "category"
    t.string "frequency"
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "passwords", force: :cascade do |t|
    t.string "value"
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_passwords_on_user_id"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "user_infos", force: :cascade do |t|
    t.decimal "rent"
    t.decimal "income"
    t.decimal "savings"
    t.decimal "checking"
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "debt"
    t.decimal "will_save"
    t.decimal "will_pay_debt"
    t.index ["user_id"], name: "index_user_infos_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "expenses", "users"
  add_foreign_key "passwords", "users"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "user_infos", "users"
end
