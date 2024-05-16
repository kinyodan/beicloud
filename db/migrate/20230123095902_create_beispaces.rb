# frozen_string_literal: true

class CreateBeispaces < ActiveRecord::Migration[7.0]
  def change
    create_table :beispaces do |t|
      t.integer :user_id
      t.string :subdomain
      t.string :designation
      t.integer :app_count

      t.timestamps
    end
  end
end
