# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
  include ApiServices
  include AuthenticationService

  # GET|POST /users/auth/github/callback
  def github
    auth = request.env['omniauth.auth']

    unless auth&.provider == 'github' && auth&.uid.present?
      redirect_to new_user_session_path, alert: 'GitHub authentication failed. Please try again.'
      return
    end

    @user = User.from_omniauth(auth)

    if @user.persisted?
      store_github_repos_url(auth)

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
    else
      session['devise.github_data'] = auth.except('extra')

      redirect_to new_user_registration_url,
                  alert: 'We could not sign you in automatically. Please complete your profile.'
    end
  end

  def failure
    redirect_to root_path,
                alert: failure_message || 'Authentication failed. Please try again.'
  end

  private

  # Stores GitHub repos URL in a signed/encrypted cookie
  # todo!! move this to a dedicated service or User model method later
  def store_github_repos_url(auth)
    repos_url = auth.dig('extra', 'raw_info', 'repos_url')

    if repos_url.present?
      cookies.signed[:github_repos_url] = {
        value:   repos_url,
        expires: 30.days.from_now,       
        secure:  Rails.env.production?,
        httponly: true
      }

      Rails.logger.info("Stored GitHub repos URL for user #{@user.id}")
    else
      Rails.logger.warn("No repos_url found in GitHub auth for user #{@user&.id}")
    end
  end
end