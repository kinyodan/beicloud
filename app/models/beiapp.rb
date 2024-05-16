# frozen_string_literal: true

require 'securerandom'

class Beiapp < ApplicationRecord
  after_create :create_onboarding

  def create_onboarding
    uuid = SecureRandom.hex(10)
    Onboarding.create(uuid: uuid, status: 'created', beiapp_id: id, state: 'created')
  end
end
