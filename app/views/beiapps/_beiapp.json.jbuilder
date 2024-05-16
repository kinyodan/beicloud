# frozen_string_literal: true

json.extract! beiapp, :id, :name, :beispace_id, :application_stack, :code_stack, :code_stack_version,
              :primary_dependency_stack, :database_stack, :database_version, :summary, :owner_name, :owner_contact_phone, :owner_location, :owner_website, :owner_contact_email, :owner_social_twitter, :owner_social_github, :owner_social_instagram, :created_at, :updated_at
json.url beiapp_url(beiapp, format: :json)
