# frozen_string_literal: true

class CreateBeiapps < ActiveRecord::Migration[7.0]
  def change
    create_table :beiapps do |t|
      t.string :name
      t.integer :beispace_id
      t.string :application_stack
      t.string :code_stack
      t.string :code_stack_version
      t.string :primary_dependency_stack
      t.string :database_stack
      t.string :database_version
      t.string :summary
      t.string :owner_name
      t.string :owner_contact_phone
      t.string :owner_location
      t.string :owner_website
      t.string :owner_contact_email
      t.string :owner_social_twitter
      t.string :owner_social_github
      t.string :owner_social_instagram

      t.timestamps
    end
  end
end
