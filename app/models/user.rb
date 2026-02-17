# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         omniauth_providers: %i[github]

  has_many :beispaces, foreign_key: :owner_id, inverse_of: :owner, dependent: :restrict_with_exception
  has_many :beiapps,   through: :beispaces
  has_many :onboardings, through: :beiapps
  has_many :deployments, through: :beiapps

  validates :name,
            presence: true,
            length:   { maximum: 100 }

  validates :email,
            presence:   true,
            uniqueness: { case_sensitive: false }

  validates :github_username,
            format: { with: /\A[a-z\d](?:[a-z\d]|-(?=[a-z\d])){0,38}\z/i, allow_blank: true }

  before_validation :normalize_github_fields, if: :github_provider?

  def self.from_omniauth(auth)
    # Find or create user based on provider + uid
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)

    if user.new_record?
      user.assign_attributes(
        email:       auth.info.email,
        name:        auth.info.name.presence || auth.info.nickname,
        github_username: auth.info.nickname,
        avatar_url:  auth.info.image,
        password:    Devise.friendly_token[0, 20] 
      )
    end

    user.assign_attributes(
      provider_token:     auth.credentials.token,
      provider_refresh_token: auth.credentials.refresh_token,
      provider_expires_at: auth.credentials.expires_at,
      avatar_url:         auth.info.image.presence || user.avatar_url,
      last_sign_in_at:    Time.current
    )

    user.save!
    user
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("OmniAuth GitHub failure for uid #{auth.uid}: #{e.message}")
    nil  
  end

  def github_connected?
    provider == 'github' && uid.present?
  end

  def github_provider?
    provider == 'github'
  end

  def display_name
    name.presence || email.split('@').first || "User ##{id}"
  end

  private

  def normalize_github_fields
    self.github_username = github_username.to_s.strip.presence
    self.email           = email.to_s.strip.downcase.presence if email_changed?
  end
end