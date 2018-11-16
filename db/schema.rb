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

ActiveRecord::Schema.define(version: 20181116025452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "authentications", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "provider",   limit: 255, null: false
    t.string   "uid",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beans_reports", force: :cascade do |t|
    t.float    "kg_of_seed_planted"
    t.float    "bags_harvested"
    t.float    "grade_1_bags"
    t.float    "grade_2_bags"
    t.float    "ungraded_bags"
    t.string   "report_type"
    t.integer  "farmer_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "harvest_report_id"
    t.integer  "season"
    t.float    "kg_of_fertilizer"
    t.string   "status",             default: "pending"
  end

  add_index "beans_reports", ["farmer_id"], name: "index_beans_reports_on_farmer_id", using: :btree
  add_index "beans_reports", ["harvest_report_id"], name: "index_beans_reports_on_harvest_report_id", using: :btree

  create_table "black_eyed_beans_reports", force: :cascade do |t|
    t.float    "kg_of_seed_planted"
    t.float    "bags_harvested"
    t.float    "grade_1_bags"
    t.float    "grade_2_bags"
    t.float    "ungraded_bags"
    t.string   "report_type"
    t.integer  "farmer_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "harvest_report_id"
    t.integer  "season"
    t.float    "kg_of_fertilizer"
    t.string   "status",             default: "pending"
  end

  add_index "black_eyed_beans_reports", ["farmer_id"], name: "index_black_eyed_beans_reports_on_farmer_id", using: :btree
  add_index "black_eyed_beans_reports", ["harvest_report_id"], name: "index_black_eyed_beans_reports_on_harvest_report_id", using: :btree

  create_table "egranary_floats", force: :cascade do |t|
    t.float    "value"
    t.integer  "year"
    t.integer  "season"
    t.string   "txn_type"
    t.string   "currency"
    t.string   "entry_method"
    t.uuid     "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "notes"
  end

  add_index "egranary_floats", ["user_id"], name: "index_egranary_floats_on_user_id", using: :btree

  create_table "farmer_groups", force: :cascade do |t|
    t.string   "group_name"
    t.string   "short_names"
    t.string   "formal_name"
    t.integer  "registration_number"
    t.string   "country"
    t.string   "county"
    t.string   "sub_county"
    t.string   "location"
    t.text     "store_aggregation_center"
    t.text     "machinery"
    t.text     "other_buildings"
    t.text     "motor_vehicles"
    t.string   "audited_financials_upload_path"
    t.string   "management_accounts_upload_path"
    t.string   "certificate_of_registration_upload_path"
    t.string   "chairman_name"
    t.string   "chairman_phone_number"
    t.string   "chairman_email"
    t.string   "vice_chairman_name"
    t.string   "vice_chairman_phone_number"
    t.string   "vice_chairman_email"
    t.string   "secretary_name"
    t.string   "secretary_phone_number"
    t.string   "secretary_email"
    t.string   "treasurer_name"
    t.string   "treasurer_phone_number"
    t.string   "treasurer_email"
    t.float    "aggregated_harvest_data"
    t.float    "total_harvest_collected_for_sale"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "approx_farmer_count",                     default: 0
  end

  add_index "farmer_groups", ["group_name"], name: "index_farmer_groups_on_group_name", using: :btree

  create_table "farmer_inputs", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "warehouse_number"
    t.integer  "commodity_number"
    t.float    "quantity"
    t.integer  "commodity_grade"
    t.string   "phone_number",     limit: 255
    t.string   "session_id",       limit: 255
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "user_id"
  end

  create_table "farmers", force: :cascade do |t|
    t.string   "phone_number"
    t.string   "national_id_number"
    t.string   "association_name"
    t.string   "country"
    t.string   "county"
    t.string   "ward"
    t.string   "nearest_town"
    t.string   "crops",                                     array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reporting_as"
    t.string   "group_name"
    t.string   "group_registration_number"
    t.string   "name"
    t.string   "gender"
    t.integer  "year_of_birth"
    t.boolean  "accepted_loan_tnc",         default: false
    t.boolean  "received_loans",            default: false
    t.string   "pin_hash"
    t.float    "farm_size"
    t.string   "status"
  end

  add_index "farmers", ["association_name"], name: "index_farmers_on_association_name", using: :btree
  add_index "farmers", ["country"], name: "index_farmers_on_country", using: :btree
  add_index "farmers", ["county"], name: "index_farmers_on_county", using: :btree
  add_index "farmers", ["gender"], name: "index_farmers_on_gender", using: :btree
  add_index "farmers", ["group_name"], name: "index_farmers_on_group_name", using: :btree
  add_index "farmers", ["status"], name: "index_farmers_on_status", using: :btree
  add_index "farmers", ["year_of_birth"], name: "index_farmers_on_year_of_birth", using: :btree

  create_table "green_grams_reports", force: :cascade do |t|
    t.float    "kg_of_seed_planted"
    t.float    "bags_harvested"
    t.float    "grade_1_bags"
    t.float    "grade_2_bags"
    t.float    "ungraded_bags"
    t.string   "report_type"
    t.integer  "farmer_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "harvest_report_id"
    t.integer  "season"
    t.float    "kg_of_fertilizer"
    t.string   "status",             default: "pending"
  end

  add_index "green_grams_reports", ["farmer_id"], name: "index_green_grams_reports_on_farmer_id", using: :btree
  add_index "green_grams_reports", ["harvest_report_id"], name: "index_green_grams_reports_on_harvest_report_id", using: :btree

  create_table "loans", force: :cascade do |t|
    t.string   "commodity"
    t.json     "commodities_lent"
    t.float    "value"
    t.string   "time_period"
    t.integer  "season"
    t.integer  "year"
    t.float    "interest_rate"
    t.string   "interest_period"
    t.string   "interest_type"
    t.integer  "duration"
    t.string   "duration_unit"
    t.string   "currency"
    t.float    "service_charge"
    t.string   "structure"
    t.string   "status"
    t.datetime "disbursed_date"
    t.datetime "repaid_date"
    t.string   "disbursal_method"
    t.string   "repayment_method"
    t.string   "voucher_code"
    t.integer  "farmer_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.float    "amount_paid",               default: 0.0
    t.float    "service_charge_percentage", default: 0.0
  end

  add_index "loans", ["farmer_id"], name: "index_loans_on_farmer_id", using: :btree

  create_table "loans_txns", id: false, force: :cascade do |t|
    t.integer "loan_id"
    t.integer "txn_id"
    t.float   "amount_paid", default: 0.0
  end

  add_index "loans_txns", ["loan_id"], name: "index_loans_txns_on_loan_id", using: :btree
  add_index "loans_txns", ["txn_id"], name: "index_loans_txns_on_txn_id", using: :btree

  create_table "maize_reports", force: :cascade do |t|
    t.float    "acres_planted"
    t.float    "kg_of_seed_planted"
    t.string   "maize_type"
    t.string   "grade"
    t.float    "bags_to_sell"
    t.float    "kg_to_sell"
    t.integer  "farmer_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.float    "bags_harvested"
    t.float    "grade_1_bags"
    t.float    "grade_2_bags"
    t.float    "ungraded_bags"
    t.string   "report_type"
    t.integer  "harvest_report_id"
    t.integer  "season"
    t.float    "kg_of_fertilizer"
    t.string   "status",             default: "pending"
  end

  add_index "maize_reports", ["farmer_id"], name: "index_maize_reports_on_farmer_id", using: :btree
  add_index "maize_reports", ["harvest_report_id"], name: "index_maize_reports_on_harvest_report_id", using: :btree

  create_table "nerica_rice_reports", force: :cascade do |t|
    t.float    "kg_of_seed_planted"
    t.float    "acres_planted"
    t.float    "bags_harvested"
    t.float    "pishori_bags"
    t.float    "super_bags"
    t.float    "other_bags"
    t.string   "report_type"
    t.integer  "farmer_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "harvest_report_id"
    t.integer  "season"
  end

  add_index "nerica_rice_reports", ["farmer_id"], name: "index_nerica_rice_reports_on_farmer_id", using: :btree
  add_index "nerica_rice_reports", ["harvest_report_id"], name: "index_nerica_rice_reports_on_harvest_report_id", using: :btree

  create_table "old_loans", force: :cascade do |t|
    t.string   "loan_type"
    t.float    "amount"
    t.integer  "season"
    t.datetime "disbursed_date"
    t.datetime "repaid_date"
    t.float    "service_charge"
    t.string   "disbursal_method"
    t.string   "repayment_method"
    t.string   "voucher_code"
    t.integer  "farmer_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "old_loans", ["farmer_id"], name: "index_old_loans_on_farmer_id", using: :btree

  create_table "pigeon_peas_reports", force: :cascade do |t|
    t.float    "kg_of_seed_planted"
    t.float    "acres_planted"
    t.float    "bags_harvested"
    t.float    "grade_1_bags"
    t.float    "grade_2_bags"
    t.float    "ungraded_bags"
    t.string   "report_type"
    t.integer  "season"
    t.integer  "farmer_id"
    t.integer  "pigeon_peas_reports_id"
    t.integer  "harvest_report_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.float    "kg_of_fertilizer"
    t.string   "status",                 default: "pending"
  end

  add_index "pigeon_peas_reports", ["farmer_id"], name: "index_pigeon_peas_reports_on_farmer_id", using: :btree
  add_index "pigeon_peas_reports", ["harvest_report_id"], name: "index_pigeon_peas_reports_on_harvest_report_id", using: :btree
  add_index "pigeon_peas_reports", ["pigeon_peas_reports_id"], name: "index_pigeon_peas_reports_on_pigeon_peas_reports_id", using: :btree
  add_index "pigeon_peas_reports", ["season"], name: "index_pigeon_peas_reports_on_season", using: :btree

  create_table "rice_reports", force: :cascade do |t|
    t.float    "acres_planted"
    t.float    "kg_of_seed_planted"
    t.float    "kg_stored"
    t.string   "rice_type"
    t.string   "grain_type"
    t.string   "aroma_type"
    t.float    "bags_to_sell"
    t.float    "kg_to_sell"
    t.integer  "farmer_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.float    "bags_harvested"
    t.float    "pishori_bags"
    t.float    "super_bags"
    t.float    "other_bags"
    t.string   "report_type"
    t.integer  "harvest_report_id"
    t.integer  "season"
    t.float    "kg_of_fertilizer"
    t.string   "status",             default: "pending"
  end

  add_index "rice_reports", ["farmer_id"], name: "index_rice_reports_on_farmer_id", using: :btree
  add_index "rice_reports", ["harvest_report_id"], name: "index_rice_reports_on_harvest_report_id", using: :btree

  create_table "sent_messages", force: :cascade do |t|
    t.string   "to",              limit: 60
    t.string   "from",            limit: 60
    t.text     "message"
    t.integer  "num_sent"
    t.string   "gender"
    t.string   "age_demographic"
    t.string   "country"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.uuid     "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "soya_beans_reports", force: :cascade do |t|
    t.float    "kg_of_seed_planted"
    t.float    "acres_planted"
    t.float    "bags_harvested"
    t.float    "grade_1_bags"
    t.float    "grade_2_bags"
    t.float    "ungraded_bags"
    t.string   "report_type"
    t.integer  "season"
    t.integer  "farmer_id"
    t.integer  "soya_beans_reports_id"
    t.integer  "harvest_report_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.float    "kg_of_fertilizer"
    t.string   "status",                default: "pending"
  end

  add_index "soya_beans_reports", ["farmer_id"], name: "index_soya_beans_reports_on_farmer_id", using: :btree
  add_index "soya_beans_reports", ["harvest_report_id"], name: "index_soya_beans_reports_on_harvest_report_id", using: :btree
  add_index "soya_beans_reports", ["season"], name: "index_soya_beans_reports_on_season", using: :btree
  add_index "soya_beans_reports", ["soya_beans_reports_id"], name: "index_soya_beans_reports_on_soya_beans_reports_id", using: :btree

  create_table "txns", force: :cascade do |t|
    t.float    "value"
    t.string   "account_id"
    t.string   "completed_at"
    t.string   "name"
    t.string   "txn_type"
    t.string   "phone_number"
    t.integer  "farmer_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "txns", ["farmer_id"], name: "index_txns_on_farmer_id", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "phone_number",                    limit: 255
    t.string   "email",                           limit: 255,                    null: false
    t.string   "crypted_password",                limit: 255
    t.string   "salt",                            limit: 255
    t.string   "first_name",                      limit: 255
    t.string   "last_name",                       limit: 255
    t.string   "country",                         limit: 255,                    null: false
    t.string   "username",                        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token",               limit: 255
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token",            limit: 255
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address",      limit: 255
    t.integer  "failed_logins_count",                         default: 0
    t.datetime "lock_expires_at"
    t.string   "unlock_token",                    limit: 255
    t.string   "activation_state",                limit: 255
    t.string   "activation_token",                limit: 255
    t.datetime "activation_token_expires_at"
    t.string   "role",                                        default: "viewer"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

end
