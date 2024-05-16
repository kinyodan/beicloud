# frozen_string_literal: true

class Deployment < ApplicationRecord
  default_scope { order(created_at: :desc) }
end
