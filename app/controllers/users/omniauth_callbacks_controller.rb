# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # You should configure your model like this:
    # devise :omniauthable, omniauth_providers: [:github]

    # You should also create an action method in this controller like this:
    # def twitter
    # end

    # def github
    #   p "Users::OmniauthCallbacksController"
    #   @user = User.from_omniauth(request.env["omniauth.auth"])
    #   signin_and_redirect @user
    # end

    def github
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
      else
        session['devise.github_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
      super
    end

    # More info at:
    # https://github.com/heartcombo/devise#omniauth

    # GET|POST /resource/auth/twitter
    def passthru
      p 'passthru--passthru'
      super
    end

    # GET|POST /users/auth/twitter/callback
    def failure
      p 'failure--failure'
      p params
      super
      root_url
    end

    # protected

    # The path used when OmniAuth fails
    # def after_omniauth_failure_path_for(scope)
    #   super(scope)
    # end
  end
end
