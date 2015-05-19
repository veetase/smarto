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

ActiveRecord::Schema.define(version: 20150518062919) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "spots", force: :cascade do |t|
    t.integer   "perception_value"
    t.string    "perception_tags",                                                                                         array: true
    t.text      "comment",                                                                                    null: false
    t.float     "avg_temperature",                                                                            null: false
    t.float     "mid_temperature",                                                                            null: false
    t.float     "max_temperature",                                                                            null: false
    t.float     "min_temperature",                                                                            null: false
    t.datetime  "start_measure_time",                                                                         null: false
    t.integer   "measure_duration"
    t.string    "image",                                                                                      null: false
    t.string    "image_shaped",                                                                               null: false
    t.boolean   "is_public",                                                                   default: true
    t.geography "location",           limit: {:srid=>4326, :type=>"point", :geographic=>true},                null: false
    t.integer   "user_id"
    t.integer   "category",                                                                    default: 1,    null: false
  end

  add_index "spots", ["location"], name: "index_spots_on_location", using: :gist

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "auth_token"
    t.datetime "auth_token_expire_at"
    t.string   "nick_name",                          default: ""
    t.string   "avatar",                             default: ""
    t.integer  "gender",                   limit: 2
    t.string   "tags",                                                         array: true
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.string   "unconfirmed_email"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "reset_password_expire_at"
    t.string   "phone"
    t.integer  "dou_id"
    t.integer  "figure"
    t.integer  "age"
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "confirmation_expire_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["dou_id"], name: "index_users_on_dou_id", unique: true, using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weather_station_spots", force: :cascade do |t|
    t.float    "max_temperature", null: false
    t.float    "min_temperature", null: false
    t.float    "altitude"
    t.string   "area_id"
    t.datetime "publish_time"
  end

end
