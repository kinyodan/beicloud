# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :github, "145234351daf9164059c", "37bbd9139b269fa2d45ed63f45cdd2f299ed9952"
  #  config.omniauth :github, "145234351daf9164059c", "37bbd9139b269fa2d45ed63f45cdd2f299ed9952", scope: 'user:email'

  p 'GET https://github.com/login/oauth/authorize   '
end
