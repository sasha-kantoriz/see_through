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

ActiveRecord::Schema.define(version: 20160823083621) do

  create_table "commentors", force: :cascade do |t|
    t.integer  "pull_request_id"
    t.string   "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "daily_reports", force: :cascade do |t|
    t.string   "user_name"
    t.string   "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pull_request_metrics", force: :cascade do |t|
    t.string  "author"
    t.string  "number",            null: false
    t.string  "repo"
    t.string  "title"
    t.boolean "merged"
    t.boolean "mergeable"
    t.string  "mergeable_state"
    t.string  "create_time"
    t.string  "update_time"
    t.string  "state"
    t.string  "additions"
    t.string  "deletions"
    t.string  "changed_files"
    t.string  "commits"
    t.string  "comments"
    t.string  "committers"
    t.string  "commentors"
    t.string  "head_label"
    t.string  "base_sha"
    t.string  "head_sha"
    t.string  "added_to_database", null: false
  end

  create_table "pull_requests", force: :cascade do |t|
    t.string   "repo"
    t.string   "title",             null: false
    t.string   "pr_id",             null: false
    t.string   "author",            null: false
    t.boolean  "merged",            null: false
    t.boolean  "mergeable"
    t.string   "mergeable_state"
    t.string   "state"
    t.string   "pr_commentors"
    t.string   "committer"
    t.string   "labels"
    t.string   "pr_create_time"
    t.string   "pr_update_time"
    t.string   "added_to_database"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "repo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "user_login"
    t.string   "user_email"
    t.string   "git_email"
    t.integer  "git_hub_id"
    t.string   "notify_at"
    t.boolean  "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slack_id"
  end

end
