# frozen_string_literal: true

json.extract! beispace, :id, :user_id, :subdomain, :designation, :app_count, :created_at, :updated_at
json.url beispace_url(beispace, format: :json)
