# frozen_string_literal: true

module AuthenticationService
  extend ActiveSupport::Concern

  include CookiesManagerService

  included do
    helper_method :current_beispace_user if respond_to?(:helper_method)
  end

  def verify_authentication
    return if current_beispace_user.present?

    if params[:s].present?
      handle_token_authentication(params[:s])
    else
      redirect_to_login unless controller_name.in?(%w[home sessions callbacks])
    end
  end

  private

  def handle_token_authentication(token)
    auth_response = verify_auth_token(token)

    if auth_response&.dig('status') == true
      if set_authentication_cookies(token)
        Rails.logger.info("Authentication successful via token for path: #{request.path}")
        redirect_to root_path, notice: "Welcome back!"
      else
        Rails.logger.warn("Failed to set auth cookies after successful token verification")
        redirect_to_login(alert: "Authentication setup failed. Please try again.")
      end
    else
      Rails.logger.warn("Invalid or expired token: #{token[0..10]}...")
      redirect_to_login(alert: "Session invalid or expired.")
    end
  end

  # Calls the central auth API to verify the token
  # Returns parsed JSON or nil on failure
  def verify_auth_token(token)
    ApiServices.verify_authentication(token)
  end

  # Returns true if successful
  def set_authentication_cookies(token)
    return false unless token.present?

    auth_set   = authentication_set_auth_cookies(token)
    beispace_set = authentication_set_Beispace_cookies_from_token(token)

    auth_set && beispace_set
  end

  # Redirect to central login with source tracking
  def redirect_to_login(options = {})
    url = "#{ENV.fetch('BEIMARKET_URL')}/users/sign_in?src=beicloud"
    redirect_to url, allow_other_host: true, **options
  end

end