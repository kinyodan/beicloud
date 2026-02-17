# frozen_string_literal: true

class GitControlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :clone_repo

  # POST /git_control/clone_repo (or whatever your route is)
  def clone_repo
    required_params = %i[repo_url id onboarding_id beiapp_id]
    missing = required_params - params.keys.map(&:to_sym)

    if missing.any?
      return render json: {
        status: false,
        message: "Missing required parameters: #{missing.join(', ')}"
      }, status: :bad_request
    end

    # Create deployment record synchronously 
    deployment = create_deployment_record(params)

    GitDeploymentJob.perform_later(
      repo_url:     params[:repo_url],
      onboarding_id: params[:onboarding_id],
      beiapp_id:    params[:beiapp_id],
      deployment_id: deployment.id,
      user_id:      current_beispace_user&.id 
    )

    render json: {
      status: true,
      message: 'Deployment initiated',
      deployment_id: deployment.id,
      uuid: deployment.uuid
    }, status: :accepted 
  rescue StandardError => e
    Rails.logger.error("Git clone initiation failed: #{e.message}\n#{e.backtrace.first(5).join("\n")}")
    render json: { status: false, message: 'Failed to initiate deployment' }, status: :internal_server_error
  end

  def index
    @deployments = current_user_deployments.page(params[:page])
    head :ok
  end

  private

  def create_deployment_record(params)
    uuid = SecureRandom.uuid 

    Deployment.create!(
      name: "BeiApp Deployment ##{params[:beiapp_id]}",
      body: "Onboarding ##{params[:id]}",
      onboarding_id: params[:onboarding_id],
      beiapp_id: params[:beiapp_id],
      uuid: uuid,
      status: 'initiated', 
      initiated_at: Time.current
    )
  end
end