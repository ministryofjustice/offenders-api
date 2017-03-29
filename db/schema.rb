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

ActiveRecord::Schema.define(version: 20170227122233) do

  create_table "identities", id: :string, force: :cascade do |t|
    t.string "offender_id"
    t.string "noms_offender_id"
    t.string "title"
    t.string "given_name_1"
    t.string "given_name_2"
    t.string "surname"
    t.string "suffix"
    t.date   "date_of_birth"
    t.string "gender"
    t.string "pnc_number"
    t.string "cro_number"
    t.string "status",           default: "inactive"
    t.string "ethnicity_code"
    t.string "given_name_3"
    t.index ["cro_number"], name: "index_identities_on_cro_number"
    t.index ["given_name_1"], name: "index_identities_on_given_name_1"
    t.index ["noms_offender_id"], name: "index_identities_on_noms_offender_id"
    t.index ["offender_id"], name: "index_identities_on_offender_id"
    t.index ["pnc_number"], name: "index_identities_on_pnc_number"
    t.index ["surname"], name: "index_identities_on_surname"
  end

  create_table "imports", force: :cascade do |t|
    t.string   "offenders_file"
    t.string   "identities_file"
    t.string   "status",          default: "in_progress"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nicknames", force: :cascade do |t|
    t.string   "name"
    t.integer  "nickname_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id",                    null: false
    t.integer  "application_id",                       null: false
    t.string   "token",                                null: false
    t.integer  "expires_in",                           null: false
    t.text     "redirect_uri",      limit: 2147483647, null: false
    t.datetime "created_at",                           null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, where: "([refresh_token] IS NOT NULL)"
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, where: "([token] IS NOT NULL)"
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                                         null: false
    t.string   "uid",                                          null: false
    t.string   "secret",                                       null: false
    t.text     "redirect_uri", limit: 2147483647,              null: false
    t.string   "scopes",                          default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "offenders", id: :string, force: :cascade do |t|
    t.uuid     "current_identity_id"
    t.string   "noms_id"
    t.string   "nationality_code"
    t.string   "establishment_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "merged_to_id"
    t.index ["current_identity_id"], name: "index_offenders_on_current_identity_id"
    t.index ["noms_id"], name: "index_offenders_on_noms_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "md5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["md5"], name: "index_uploads_on_md5"
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
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, where: "([reset_password_token] IS NOT NULL)"
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                     null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 2147483647
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
