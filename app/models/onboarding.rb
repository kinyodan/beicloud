# frozen_string_literal: true

class Onboarding < ApplicationRecord
  belongs_to :beiapp
  belongs_to :user, optional: true         
  belongs_to :beispace, through: :beiapp   

  has_many   :deployments, dependent: :destroy

  # status: overall progress
  enum :status, {
    created:     'created',
    in_progress: 'in_progress',
    completed:   'completed',
    failed:      'failed',
    cancelled:   'cancelled',
    archived:    'archived'
  }, default: :created

  enum :state, {
    pending_setup:      'pending_setup',
    repo_selected:      'repo_selected',
    branch_selected:    'branch_selected',
    config_review:      'config_review',
    deploying:          'deploying',
    post_deployment:    'post_deployment',
    finished:           'finished'
  }, default: :pending_setup, _prefix: true

  validates :uuid, 
            presence:   true, 
            uniqueness: true

  validates :beiapp_id, 
            presence: true

  validates :status, 
            presence: true

  validates :state, 
            presence: true, 
            allow_nil: true  

  # prevent duplicate active onboardings per Beiapp
  validate :only_one_active_onboarding_per_beiapp, on: :create

  default_scope { order(created_at: :desc) }

  scope :active,       -> { where.not(status: %w[completed failed cancelled archived]) }
  scope :completed,    -> { where(status: 'completed') }
  scope :failed,       -> { where(status: 'failed') }
  scope :for_beiapp,   ->(beiapp) { where(beiapp: beiapp) }
  scope :recent,       -> { limit(10) }

  before_validation :generate_uuid, on: :create
  after_create      :log_onboarding_start
  after_update      :track_completion_if_finished

  def active?
    status.in? %w[created in_progress]
  end

  def finished?
    status.in? %w[completed failed cancelled archived]
  end

  def success?
    status == 'completed'
  end

  def current_step
    state&.humanize || status.humanize
  end

  def duration
    return nil unless started_at && finished_at
    finished_at - started_at
  end

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def log_onboarding_start
    Rails.logger.info("Onboarding started for BeiApp ##{beiapp_id} – UUID: #{uuid}")
  end

  def track_completion_if_finished
    return unless saved_change_to_status? && finished?

    self.finished_at ||= Time.current if success?
    Rails.logger.info("Onboarding #{uuid} finished with status: #{status}")
    # Future: send notification, create audit log, update Beiapp status, etc.
  end

  def only_one_active_onboarding_per_beiapp
    if beiapp&.onboardings&.active&.where.not(id: id)&.exists?
      errors.add(:base, "An active onboarding already exists for this BeiApp")
    end
  end
end