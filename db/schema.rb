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

ActiveRecord::Schema[7.0].define(version: 2024_09_13_095404) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "covers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "project"
    t.text "resume"
    t.string "aasm_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_covers_on_user_id"
  end

  create_table "credit_transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount", null: false
    t.string "transaction_type", null: false
    t.string "description", null: false
    t.string "transactionable_type", null: false
    t.bigint "transactionable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transactionable_type", "transactionable_id"], name: "index_credit_transactions_on_transactionable"
    t.index ["user_id"], name: "index_credit_transactions_on_user_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.integer "credits"
    t.integer "price_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "package_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_purchases_on_package_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "resumes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "resume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_resumes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "credits", default: 0
  end

  add_foreign_key "covers", "users"
  add_foreign_key "credit_transactions", "users"
  add_foreign_key "purchases", "packages"
  add_foreign_key "purchases", "users"
  add_foreign_key "resumes", "users"
end
