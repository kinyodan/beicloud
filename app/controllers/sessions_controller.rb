# frozen_string_literal: true

# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  # This controller acts as an authentication bridge.
  # BeiCloud does NOT manage sessions directly — all auth is delegated to the central
  # BeiMarket platform (single source of truth for users, sessions, and SSO).

  # GET/POST /sessions/create Redirect to central BeiMarket sign-in
  def create
    redirect_to sign_in_url, allow_other_host: true
  end

  # Callback endpoint after central auth (e.g. GitHub OAuth redirect back to BeiCloud)
  # Currently just a placeholder — extend later if you need to sync data
  def auth
    Rails.logger.info("Auth callback received — user redirected from central auth (e.g. GitHub via BeiMarket)")
    # Future: sync user data, set local cookies if needed, etc.
    redirect_to root_path, notice: "Successfully authenticated via BeiMarket"
  end

  # GET/POST /sessions/destroy Logout by clearing local cookies + redirect to central logout
  def destroy
    if clear_authentication_cookies
      Rails.logger.info("User logged out — local auth cookies cleared")
      redirect_to logout_url, allow_other_host: true, notice: "You have been logged out."
    else
      Rails.logger.warn("Failed to clear authentication cookies during logout")
      redirect_to root_path, alert: "Logout failed. Please try again."
    end
  end

  private

  # Central BeiMarket sign-in URL with source tracking
  def sign_in_url
    "#{ENV.fetch('BEIMARKET_URL')}/users/sign_in?src=beicloud"
  end

  # Central logout endpoint (clears session on BeiMarket side)
  def logout_url
    "#{ENV.fetch('BEIMARKET_URL')}/?src=beicloud&act=logout"
  end

  # Clear local BeiCloud authentication cookies
  # Returns true if both cookie sets were successfully cleared
  def clear_authentication_cookies
    authentication_set_auth_cookies('null') && authentication_set_Beispace_cookies('null')
  end
end