# frozen_string_literal: true

module CookiesManagerService
  extend ActiveSupport::Concern

  private

  # Sets the cookie that holds the current authenticated user's session data
  #
  # @param auth_data [String, Hash, JSON] Usually the token or serialized user info
  # @return [Boolean] true if cookie was set successfully
  def authentication_set_auth_cookies(auth_data)
    set_signed_cookie(
      name:     :beispace_current_user,
      value:    auth_data.to_s,
      expires:  1.year.from_now,
      options:  common_cookie_options
    )
  end

  # Sets the current Beispace / workspace identifier cookie
  #
  # @param beispace_id [String, Integer] Usually the beispace ID or subdomain
  # @return [Boolean] true if cookie was set successfully
  def authentication_set_Beispace_cookies(beispace_id)
    set_signed_cookie(
      name:     :beispace,
      value:    beispace_id.to_s,
      expires:  1.year.from_now,
      options:  common_cookie_options
    )
  end

  # Stores the GitHub repos API URL (used later for fetching repo lists)
  #
  # @param repos_url [String] Full GitHub repos_url from OAuth
  # @return [Boolean] true if cookie was set successfully
  def authentication_setting_repo_urlcookie(repos_url)
    set_signed_cookie(
      name:     :git_repos_url,
      value:    repos_url.to_s,
      expires:  30.days.from_now,   
      options:  common_cookie_options.merge(httponly: true)  
    )
  end

  def common_cookie_options
    {
      domain:   ENV.fetch('COOKIE_DOMAIN', '.beicloud.com'), 
      secure:   Rails.env.production?,
      httponly: true,          
      samesite: :lax,          
      path:     '/'
    }
  end

  def set_signed_cookie(name:, value:, expires:, options: {})
    return false if value.blank?

    cookies.signed[name] = {
      value:   value,
      expires: expires,
      **options
    }

    true
  rescue StandardError => e
    Rails.logger.error do
      "Failed to set cookie #{name.inspect}: #{e.class} – #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    end
    false
  end
end