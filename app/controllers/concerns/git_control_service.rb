# frozen_string_literal: true

module GitControlService
  extend ActiveSupport::Concern

  def git_control_fetch_Git_Repos(repos_url)
    api_services_request_get_Product(repos_url)
  end
end
