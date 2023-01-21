class CreateOnboardings < ActiveRecord::Migration[7.0]
  def change
    create_table :onboardings do |t|
      t.integer :user_id
      t.string :subdomain
      t.string :uuid
      t.string :status
      t.string :state

      t.timestamps
    end
  end
end
