# frozen_string_literal: true

class CreateDeployments < ActiveRecord::Migration[7.0]
  def change
    create_table :deployments do |t|
      t.string :name
      t.string :body
      t.integer :onboarding_id
      t.integer :beiapp_id
      t.string :uuid
      t.string :status
      t.string :messege
      t.string :stopped_at

      t.timestamps
    end
  end
end
