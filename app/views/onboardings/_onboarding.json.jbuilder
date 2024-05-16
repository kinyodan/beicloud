# frozen_string_literal: true

json.extract! onboarding, :id, :user_id, :subdomain, :uuid, :status, :state, :created_at, :updated_at
json.url onboarding_url(onboarding, format: :json)
