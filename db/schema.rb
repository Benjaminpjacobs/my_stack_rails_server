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

ActiveRecord::Schema.define(version: 20170831195818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id"
    t.hstore "message"
    t.integer "status", default: 0
    t.index ["message"], name: "index_messages_on_message", using: :gist
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "provider"
    t.string "token"
    t.string "uid"
    t.string "username"
  end

  create_table "users_services", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "service_id"
    t.index ["service_id"], name: "index_users_services_on_service_id"
    t.index ["user_id"], name: "index_users_services_on_user_id"
  end

  add_foreign_key "messages", "users"
  add_foreign_key "users_services", "services"
  add_foreign_key "users_services", "users"
end
