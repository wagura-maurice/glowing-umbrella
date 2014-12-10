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

ActiveRecord::Schema.define(version: 20141210073608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "authentications", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "channel_type",        default: "phone_number"
    t.string   "phone_number"
    t.string   "status",              default: "created"
    t.string   "name"
    t.uuid     "publisher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "subscribe_message"
    t.text     "unsubscribe_message"
  end

  create_table "channels_subscribers", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid "channel_id"
    t.uuid "subscriber_id"
  end

  create_table "farmer_inputs", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.integer  "warehouse_number"
    t.integer  "commodity_number"
    t.float    "quantity"
    t.integer  "commodity_grade"
    t.string   "phone_number"
    t.string   "session_id"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "user_id"
  end

  create_table "messages", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "direction"
    t.boolean  "read"
    t.string   "to"
    t.string   "from"
    t.text     "content"
    t.datetime "time"
    t.datetime "time_read"
    t.uuid     "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missed_calls", force: true do |t|
    t.uuid     "channel_id"
    t.uuid     "subscriber_id"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from"
    t.string   "to"
    t.string   "action"
  end

  create_table "publishers", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.uuid     "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "subscribers", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "phone_number",                                null: false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "country",                                     null: false
    t.string   "username",                                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
    t.integer  "failed_logins_count",             default: 0
    t.datetime "lock_expires_at"
    t.string   "unlock_token"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.uuid     "publisher_id"
    t.uuid     "subscriber_id"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token", using: :btree
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  add_index "users", ["username", "phone_number"], name: "index_users_on_username_and_phone_number", using: :btree

end
