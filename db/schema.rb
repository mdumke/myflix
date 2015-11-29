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

ActiveRecord::Schema.define(version: 20151128204306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "queue_items", force: true do |t|
    t.integer  "queue_position"
    t.integer  "video_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "relationships", force: true do |t|
    t.integer "leader_id"
    t.integer "follower_id"
  end

  create_table "reviews", force: true do |t|
    t.integer  "rating"
    t.text     "text"
    t.integer  "video_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree
  add_index "reviews", ["video_id"], name: "index_reviews_on_video_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "videos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "category_id"
    t.string   "large_cover_url"
    t.string   "small_cover_url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
