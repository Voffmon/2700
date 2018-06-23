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

ActiveRecord::Schema.define(version: 20160704160134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.integer  "setup_id"
    t.string   "name",       null: false
    t.string   "dimension",  null: false
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_identities_on_uid", using: :btree
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "plan_months", force: :cascade do |t|
    t.integer  "position_id"
    t.integer  "month"
    t.decimal  "col1"
    t.decimal  "col1_forecast"
    t.boolean  "col1_is_user_generated"
    t.boolean  "col1_is_user_generated_forecast"
    t.decimal  "col2"
    t.decimal  "col2_forecast"
    t.boolean  "col2_is_user_generated"
    t.boolean  "col2_is_user_generated_forecast"
    t.decimal  "col3"
    t.decimal  "col3_forecast"
    t.boolean  "col3_is_user_generated"
    t.boolean  "col3_is_user_generated_forecast"
    t.decimal  "col4"
    t.decimal  "col4_forecast"
    t.boolean  "col4_is_user_generated"
    t.boolean  "col4_is_user_generated_forecast"
    t.text     "note"
    t.text     "note_forecast"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["position_id"], name: "index_plan_months_on_position_id", using: :btree
  end

  create_table "positions", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name",                                          null: false
    t.integer  "vat"
    t.string   "active_state",               default: "active"
    t.string   "active_state_before_locked"
    t.boolean  "needs_attention"
    t.string   "sales_method"
    t.string   "costs_method"
    t.string   "field1"
    t.string   "field1_forecast"
    t.string   "field2"
    t.string   "field2_forecast"
    t.string   "field3"
    t.string   "field3_forecast"
    t.string   "field4"
    t.string   "field4_forecast"
    t.string   "field5"
    t.string   "field5_forecast"
    t.boolean  "has_to_be_repayed"
    t.integer  "order"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "presets", force: :cascade do |t|
    t.integer  "venture_id"
    t.string   "name"
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venture_id"], name: "index_presets_on_venture_id", using: :btree
  end

  create_table "setups", force: :cascade do |t|
    t.integer  "venture_id"
    t.integer  "year"
    t.boolean  "is_locked",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "position_id"
    t.integer  "venture_id"
    t.datetime "date"
    t.string   "title"
    t.decimal  "amount",      null: false
    t.integer  "vat",         null: false
    t.text     "note"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "role",                   default: "user"
    t.string   "state",                  default: "blocked"
    t.string   "name",                   default: "",        null: false
    t.string   "language",               default: "de"
    t.text     "bio"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "ventures", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",               null: false
    t.text     "description"
    t.string   "currency",           null: false
    t.string   "taxes_report_cycle"
    t.integer  "vat"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_foreign_key "identities", "users"
end
