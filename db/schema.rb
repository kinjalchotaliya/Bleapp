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

ActiveRecord::Schema.define(version: 20170210160201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agent_infos", force: :cascade do |t|
    t.string   "office_phone"
    t.string   "asso_agency"
    t.string   "license_no"
    t.integer  "user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "is_enable",           default: false
  end

  add_index "agent_infos", ["user_id"], name: "index_agent_infos_on_user_id", using: :btree

  create_table "authentication_tokens", force: :cascade do |t|
    t.string   "auth_token"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "authentication_tokens", ["user_id"], name: "index_authentication_tokens_on_user_id", using: :btree

  create_table "beacons", force: :cascade do |t|
    t.string   "uuid"
    t.string   "name"
    t.text     "description"
    t.string   "date"
    t.boolean  "is_filter",   default: false
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "beacons", ["user_id"], name: "index_beacons_on_user_id", using: :btree

  create_table "ble_images", force: :cascade do |t|
    t.integer  "bleeapp_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "ble_images", ["bleeapp_id"], name: "index_ble_images_on_bleeapp_id", using: :btree

  create_table "bleeapps", force: :cascade do |t|
    t.string   "title"
    t.string   "tags"
    t.text     "description"
    t.integer  "property_id"
    t.integer  "beacon_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "ble_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "minor"
    t.string   "major"
    t.string   "name"
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
    t.datetime "audio_updated_at"
  end

  add_index "bleeapps", ["beacon_id"], name: "index_bleeapps_on_beacon_id", using: :btree
  add_index "bleeapps", ["property_id"], name: "index_bleeapps_on_property_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "property_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "documents", ["property_id"], name: "index_documents_on_property_id", using: :btree

  create_table "favorite_properties", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "property_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "favorite_properties", ["property_id"], name: "index_favorite_properties_on_property_id", using: :btree
  add_index "favorite_properties", ["user_id"], name: "index_favorite_properties_on_user_id", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "rate"
    t.boolean  "intrested"
    t.boolean  "contactable"
    t.text     "comments"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "property_id"
  end

  add_index "feedbacks", ["property_id"], name: "index_feedbacks_on_property_id", using: :btree
  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id", using: :btree

  create_table "highlights", force: :cascade do |t|
    t.string   "title"
    t.text     "note"
    t.integer  "property_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
  end

  add_index "highlights", ["property_id"], name: "index_highlights_on_property_id", using: :btree
  add_index "highlights", ["user_id"], name: "index_highlights_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "property_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "is_starred",         default: false
  end

  add_index "images", ["property_id"], name: "index_images_on_property_id", using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "status"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.float    "lat",        default: 0.0
    t.float    "lon",        default: 0.0
    t.boolean  "is_active",  default: true
  end

  add_index "properties", ["user_id"], name: "index_properties_on_user_id", using: :btree

  create_table "property_details", force: :cascade do |t|
    t.string   "property_type"
    t.string   "style"
    t.integer  "price",         limit: 8
    t.float    "sqft"
    t.float    "lot_size"
    t.string   "yeat_built"
    t.string   "beds"
    t.string   "baths"
    t.string   "mls"
    t.string   "garage"
    t.string   "heat"
    t.string   "air"
    t.string   "water"
    t.string   "sewer"
    t.text     "description"
    t.integer  "property_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "property_details", ["property_id"], name: "index_property_details_on_property_id", using: :btree

  create_table "property_schedules", force: :cascade do |t|
    t.string   "date"
    t.string   "from"
    t.string   "to"
    t.integer  "property_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "property_schedules", ["property_id"], name: "index_property_schedules_on_property_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.integer  "mile_for_filter"
    t.integer  "mile_for_list"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "user_settings", force: :cascade do |t|
    t.boolean  "contact_by_email"
    t.boolean  "contact_by_sms"
    t.boolean  "work_with_agent"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "user_settings", ["user_id"], name: "index_user_settings_on_user_id", using: :btree

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
    t.string   "f_name"
    t.string   "l_name"
    t.string   "cell_phone"
    t.string   "role"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "device_type"
    t.string   "device_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visited_bleapps", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "bleeapp_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "visited_bleapps", ["bleeapp_id"], name: "index_visited_bleapps_on_bleeapp_id", using: :btree
  add_index "visited_bleapps", ["user_id"], name: "index_visited_bleapps_on_user_id", using: :btree

  add_foreign_key "agent_infos", "users"
  add_foreign_key "authentication_tokens", "users"
  add_foreign_key "ble_images", "bleeapps"
  add_foreign_key "bleeapps", "properties"
  add_foreign_key "documents", "properties"
  add_foreign_key "favorite_properties", "properties"
  add_foreign_key "favorite_properties", "users"
  add_foreign_key "feedbacks", "properties"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "highlights", "properties"
  add_foreign_key "highlights", "users"
  add_foreign_key "images", "properties"
  add_foreign_key "properties", "users"
  add_foreign_key "property_details", "properties"
  add_foreign_key "property_schedules", "properties"
  add_foreign_key "user_settings", "users"
  add_foreign_key "visited_bleapps", "bleeapps"
  add_foreign_key "visited_bleapps", "users"
end
