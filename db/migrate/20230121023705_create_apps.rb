# frozen_string_literal: true

class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.integer :user_id
      t.string :subdomain
      t.string :anchor_url
      t.string :back_up_url
      t.string :main_url
      t.string :github_account
      t.string :github_repo_name
      t.string :github_owner
      t.string :status
      t.integer :app_dashboard_id

      t.timestamps
    end
  end
end
