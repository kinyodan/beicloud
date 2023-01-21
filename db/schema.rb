# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_01_21_033529) do
  create_table "apps", force: :cascade do |t|
    t.integer "user_id"
    t.string "subdomain"
    t.string "anchor_url"
    t.string "back_up_url"
    t.string "main_url"
    t.string "github_account"
    t.string "github_repo_name"
    t.string "github_owner"
    t.string "status"
    t.integer "app_dashboard_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "onboardings", force: :cascade do |t|
    t.integer "user_id"
    t.string "subdomain"
    t.string "uuid"
    t.string "status"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
