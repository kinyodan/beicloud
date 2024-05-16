# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_230_131_130_620) do
  create_table 'apps', force: :cascade do |t|
    t.integer 'user_id'
    t.string 'subdomain'
    t.string 'anchor_url'
    t.string 'back_up_url'
    t.string 'main_url'
    t.string 'github_account'
    t.string 'github_repo_name'
    t.string 'github_owner'
    t.string 'status'
    t.integer 'app_dashboard_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'beiapps', force: :cascade do |t|
    t.string 'name'
    t.integer 'beispace_id'
    t.string 'application_stack'
    t.string 'code_stack'
    t.string 'code_stack_version'
    t.string 'primary_dependency_stack'
    t.string 'database_stack'
    t.string 'database_version'
    t.string 'summary'
    t.string 'owner_name'
    t.string 'owner_contact_phone'
    t.string 'owner_location'
    t.string 'owner_website'
    t.string 'owner_contact_email'
    t.string 'owner_social_twitter'
    t.string 'owner_social_github'
    t.string 'owner_social_instagram'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'beispaces', force: :cascade do |t|
    t.integer 'user_id'
    t.string 'subdomain'
    t.string 'designation'
    t.integer 'app_count'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'deployments', force: :cascade do |t|
    t.string 'name'
    t.string 'body'
    t.integer 'onboarding_id'
    t.integer 'beiapp_id'
    t.string 'uuid'
    t.string 'status'
    t.string 'messege'
    t.string 'stopped_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'onboardings', force: :cascade do |t|
    t.integer 'user_id'
    t.string 'subdomain'
    t.string 'uuid'
    t.string 'status'
    t.string 'state'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'beiapp_id'
    t.integer 'current_deployment_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'name', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'provider'
    t.string 'uid'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end
end
