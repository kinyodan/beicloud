# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    p "index----request.cookies['git_repos_url']"
    p request.cookies['git_repos_url']
    p "index---request.cookies['git_repos_url']"

    render layout: false
  end
end
