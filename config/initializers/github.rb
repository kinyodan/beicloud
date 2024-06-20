# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  p 'GET https://github.com/login/oauth/authorize   '
end
