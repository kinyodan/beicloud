# frozen_string_literal: true

class Deployment < ApplicationRecord
  belongs_to :beiapp
  belongs_to :onboarding

  enum :status, {
    initiated:          'initiated',
    cloning:            'cloning_repository',
    cloned:             'repository_cloned',
    building:           'building',
    built:              'built',
    deploying:          'deploying',
    deployed:           'deployed',
    failed:             'failed',
    cancelled:          'cancelled',
    rollback_in_progress: 'rollback_in_progress',
    rolled_back:        'rolled_back'
  }, default: :initiated

  validates :name, presence: true
  validates :uuid, presence: true, uniqueness: true
  validates :status, presence: true
  validates :beiapp_id, presence: true
  validates :onboarding_id, presence: true

  #validates :error_message, length: { maximum: 2000 }, allow_blank: true

  default_scope { order(created_at: :desc) }  

  scope :successful,    -> { where(status: %w[deployed built]) }
  scope :failed,        -> { where(status: 'failed') }
  scope :in_progress,   -> { where(status: %w[initiated cloning building deploying rollback_in_progress]) }
  scope :recent,        -> { limit(20) }
  scope :for_beiapp,    ->(beiapp) { where(beiapp: beiapp) }
  scope :for_onboarding, ->(onboarding) { where(onboarding: onboarding) }

  before_validation :generate_uuid, on: :create

  after_create :log_creation
  after_update :notify_status_change_if_important

  def in_progress?
    status.in? %w[initiated cloning building deploying rollback_in_progress]
  end

  def finished?
    status.in? %w[deployed failed cancelled rolled_back]
  end

  def success?
    status == 'deployed'
  end

  def duration
    return nil unless started_at && finished_at
    finished_at - started_at
  end

  def short_status
    status.to_s.humanize
  end

  def display_name
    "#{name} (#{short_status}) – #{created_at.to_fs(:short)}"
  end

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def log_creation
    Rails.logger.info("Deployment created: #{display_name} for BeiApp #{beiapp_id}")
  end

  def notify_status_change_if_important
    return unless saved_change_to_status?

    if status.in?(%w[deployed failed cancelled rolled_back])
      Rails.logger.info("Deployment status changed to #{status} for #{display_name}")
      # Future: send email / websocket notification / Slack webhook
      # DeploymentStatusBroadcastJob.perform_later(self)  # example
    end
  end
end