class GitControlController < ApplicationController
  skip_before_action :verify_authenticity_token

  def clone_repo
    p params
    onboardingServiceGetBranches(params[:repo_url], params[:id])
  end

  def index
  end
end
