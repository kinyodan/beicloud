# frozen_string_literal: true

class AddCurrentdeploymentToOnboarding < ActiveRecord::Migration[7.0]
  def change
    add_column :onboardings, :current_deployment_id, :integer
  end
end
