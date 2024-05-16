# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
  include ApiServices
  include AuthenticationService

  def github
    auth = request.env['omniauth.auth']
    github_repos_url = auth['extra'].raw_info.repos_url
    authentication_setting_repo_urlcookie(github_repos_url)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redirect @user
  end
end
