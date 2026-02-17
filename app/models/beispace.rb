# frozen_string_literal: true

class Beispace < ApplicationRecord
  belongs_to :owner, class_name: 'User', optional: true 

  has_many :beiapps,    dependent: :destroy
  has_many :onboardings, through: :beiapps
  has_many :deployments, through: :beiapps

  validates :subdomain,
            presence:   true,
            uniqueness: { case_sensitive: false },
            format:     { with:    /\A[a-z0-9]([a-z0-9-]*[a-z0-9])?\z/i,
                          message: "only lowercase letters, numbers, and hyphens allowed (no leading/trailing hyphen)" },
            length:     { minimum: 3, maximum: 63 }

  validates :designation,
            presence: true,
            length:   { maximum: 100 }

  validates :app_count, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

 # validates :status, inclusion: { in: %w[active trial suspended archived] }, allow_nil: true

  scope :active,       -> { where(status: 'active') }
  scope :by_subdomain, ->(subdomain) { find_by(subdomain: subdomain.downcase) }
  scope :recent,       -> { order(created_at: :desc) }
  scope :with_apps,    -> { where.not(app_count: 0).or(where(app_count: nil)) }

  before_validation :normalize_subdomain
  after_create      :initialize_default_resources
  before_destroy    :prevent_deletion_if_active_apps, prepend: true

  def to_param
    subdomain 
  end

  def active?
    status == 'active'
  end

  def app_limit_reached?(proposed_new_apps = 1)
    return false unless app_limit.present?
    app_count.to_i + proposed_new_apps > app_limit
  end

  def self.current
    Current.beispace 
  end

  private

  def normalize_subdomain
    self.subdomain = subdomain.to_s.strip.downcase.presence
  end

  def initialize_default_resources
    Rails.logger.info("New Beispace created: #{subdomain} (ID: #{id})")
  end

  def prevent_deletion_if_active_apps
    if beiapps.exists?
      errors.add(:base, "Cannot delete Beispace with active BeiApps. Delete or archive apps first.")
      throw(:abort)
    end
  end
end