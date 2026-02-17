# frozen_string_literal: true

class OnboardingsController < ApplicationController
  include GitControlService

  before_action :set_onboarding, only: %i[show edit update destroy]

  # GET /onboardings or /onboardings.json
  def index
    @pagy, @onboardings = pagy(current_user_onboardings.ordered, items: 20)
  end

  # GET /onboardings/1 or /onboardings/1.json
  def show
    @beiapp     = @onboarding.beiapp
    @deployments = @onboarding.deployments.order(created_at: :desc)

    @repos = fetch_github_repos || []

    # Minimal payload: only repo names (reduces JS payload size & exposure)
    # @repo_names = @repos.map { |repo| repo['name'] }.compact_blank

    gon.push(repos: @repos)
  end

  # GET /onboardings/new
  def new
    @onboarding = current_user_onboardings.new
  end

  # GET /onboardings/1/edit
  def edit; end

  # POST /onboardings or /onboardings.json
  def create
    @onboarding = current_user_onboardings.new(onboarding_params)

    respond_to do |format|
      if @onboarding.save
        format.html { redirect_to @onboarding, notice: 'Onboarding was successfully created.' }
        format.json { render :show, status: :created, location: @onboarding }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @onboarding.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /onboardings/1 or /onboardings/1.json
  def update
    respond_to do |format|
      if @onboarding.update(onboarding_params)
        format.html { redirect_to @onboarding, notice: 'Onboarding was successfully updated.' }
        format.json { render :show, status: :ok, location: @onboarding }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @onboarding.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /onboardings/1 or /onboardings/1.json
  def destroy
    @onboarding.destroy!

    respond_to do |format|
      format.html { redirect_to onboardings_url, notice: 'Onboarding was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue ActiveRecord::RecordNotDestroyed => e
    respond_to do |format|
      format.html { redirect_to onboardings_url, alert: "Cannot delete: #{e.message}" }
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  private

  # Onboardings for the current authenticated Beispace user
  def current_user_onboardings
    if current_beispace_user.present?
      current_beispace_user.onboardings 
    else
      Onboarding.none
    end
  end

  def set_onboarding
    @onboarding = current_user_onboardings.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to onboardings_url, alert: 'Onboarding not found or access denied.' }
      format.json { head :not_found }
    end
  end

  # Safe GitHub repos fetch (moved to private method for clarity & testability)
  def fetch_github_repos
    return nil unless cookies['git_repos_url'].present?

    begin
      JSON.parse(git_control_fetch_Git_Repos(cookies['git_repos_url']))
    rescue JSON::ParserError, StandardError => e
      Rails.logger.warn("Failed to fetch/parse GitHub repos: #{e.message}")
      nil
    end
  end

  def onboarding_params
    params.require(:onboarding).permit(
      :subdomain,
      :uuid,
      :status,
      :state
    )
  end
end