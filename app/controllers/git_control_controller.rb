# frozen_string_literal: true

class GitControlController < ApplicationController
  skip_before_action :verify_authenticity_token

  def clone_repo
    create_deployment(params)
    deployement = Deployment.where(onboarding_id: params['onboarding_id']).last

    if deployement
      onboarding_get_branches_and_Deploy(params[:repo_url], params[:id], params[:onboarding_id],
                                            params[:beiapp_id])
    end
  rescue StandardError
    render json: { status: false, messege: 'Problem with deployment at - CLONE REPO stage' }
  end

  def index; end

  private

  def create_deployment(params)
    uuid = SecureRandom.hex(10)
    Deployment.create(
      name: 'BeiApp deployemnt',
      body: "Onboarding-#{params['id']}",
      onboarding_id: params['onboarding_id'],
      beiapp_id: params['beiapp_id'],
      uuid: uuid,
      status: 'deployment initiated, not completed'
    )
    @deployement = Deployment.where(onboarding_id: params['onboarding_id']).last
  end
end
