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

ActiveRecord::Schema.define(version: 20151021025022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "name"
    t.string   "country",    default: "中国"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "detail"
    t.string   "zip_code"
    t.string   "tel"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "total"
    t.string   "order_no"
    t.string   "pay_method"
    t.integer  "status",       limit: 2, default: 0
    t.string   "ship_carrier"
    t.string   "ship_no"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "placements", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity",   default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "placements", ["order_id"], name: "index_placements_on_order_id", using: :btree
  add_index "placements", ["product_id"], name: "index_placements_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "title",       default: ""
    t.text     "description", default: ""
    t.decimal  "price",                       null: false
    t.boolean  "published",   default: false
    t.integer  "quantity",    default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "spot_comments", force: :cascade do |t|
    t.integer  "spot_id"
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "spot_comments", ["spot_id"], name: "index_spot_comments_on_spot_id", using: :btree

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
    t.integer   "status",             limit: 2,                                                default: 0
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.integer   "like",                                                                        default: 0
    t.float     "height",                                                                      default: 0.0
    t.integer   "comment_count",                                                               default: 0
    t.integer   "view_count",                                                                  default: 0
  end

  add_index "spots", ["created_at"], name: "index_spots_on_created_at", using: :btree
  add_index "spots", ["location"], name: "index_spots_on_location", using: :gist

  create_table "station_spots", force: :cascade do |t|
    t.string    "city"
    t.string    "name"
    t.geography "location",      limit: {:srid=>4326, :type=>"point", :geographic=>true},             null: false
    t.float     "temperature",                                                                        null: false
    t.float     "height"
    t.datetime  "created_at",                                                                         null: false
    t.datetime  "updated_at",                                                                         null: false
    t.integer   "view_count",                                                             default: 0
    t.integer   "comment_count",                                                          default: 0
    t.integer   "like",                                                                   default: 0
  end

  add_index "station_spots", ["created_at"], name: "index_station_spots_on_created_at", using: :btree
  add_index "station_spots", ["location"], name: "index_station_spots_on_location", using: :gist

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tel_attributions", force: :cascade do |t|
    t.integer "user_id"
    t.string  "province", null: false
    t.string  "city"
    t.string  "isp",      null: false
  end

  add_index "tel_attributions", ["user_id"], name: "index_tel_attributions_on_user_id", using: :btree

  create_table "temper_tips", force: :cascade do |t|
    t.float    "temper",                           null: false
    t.text     "tip",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "month_related_to",                 null: false
    t.string   "location_related_to",              null: false
    t.string   "tags",                default: [],              array: true
    t.integer  "user_id"
  end

  create_table "user_vouchers", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "voucher_id"
  end

  add_index "user_vouchers", ["user_id"], name: "index_user_vouchers_on_user_id", using: :btree
  add_index "user_vouchers", ["voucher_id"], name: "index_user_vouchers_on_voucher_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "auth_token"
    t.datetime "auth_token_expire_at"
    t.string   "nick_name",                          default: ""
    t.string   "avatar",                             default: ""
    t.integer  "gender",                   limit: 2
    t.string   "tags",                                                                   array: true
    t.string   "encrypted_password",                 default: "",           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,            null: false
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
    t.integer  "age"
    t.integer  "figure"
    t.integer  "failed_attempts",                    default: 0,            null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "confirmation_expire_at"
    t.integer  "roles_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dou_coin",                           default: 0
    t.date     "birth_date",                         default: '1990-01-01'
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["created_at"], name: "index_users_on_created_at", using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vouchers", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "ex_count"
    t.string   "code"
    t.string   "picture"
    t.string   "type"
    t.integer  "max"
    t.integer  "used_count"
    t.integer  "status",      limit: 2
    t.datetime "expire_at"
  end

  add_index "vouchers", ["code"], name: "index_vouchers_on_code", using: :btree
  add_index "vouchers", ["name"], name: "index_vouchers_on_name", using: :btree
  add_index "vouchers", ["type"], name: "index_vouchers_on_type", using: :btree

  create_table "weather_station_spots", force: :cascade do |t|
    t.float    "max_temperature", null: false
    t.float    "min_temperature", null: false
    t.float    "altitude"
    t.string   "area_id"
    t.datetime "publish_time"
  end

  add_foreign_key "orders", "users"
  add_foreign_key "placements", "orders"
  add_foreign_key "placements", "products"
end
