# frozen_string_literal: true

class BeiappsController < ApplicationController
  include GitControlService

  before_action :set_beiapp, only: %i[show edit update destroy]

  # GET /beiapps or /beiapps.json
  def index
    add_breadcrumb 'Index', beiapps_path
    @pagy, @beiapps = pagy(current_beispace_beiapps.ordered, items: 20)
  end

  # GET /beiapps/1 or /beiapps/1.json
  def show
    add_breadcrumb @beiapp.name.presence || 'Details', beiapp_path(@beiapp)

    @onboarding  = onboarding_for(@beiapp)
    @deployments = deployments_for(@onboarding)
    @repos       = git_repos_list

    @repo_names = @repos.map { |repo| repo['name'] }.compact

    gon.push(repos: @repos)
  end

  # GET /beiapps/new
  def new
    @beiapp = current_beispace_beiapps.new
  end

  # GET /beiapps/1/edit
  def edit; end

  # POST /beiapps or /beiapps.json
  def create
    @beiapp = current_beispace_beiapps.new(beiapp_params)

    respond_to do |format|
      if @beiapp.save
        format.html { redirect_to @beiapp, notice: 'Beiapp was successfully created.' }
        format.json { render :show, status: :created, location: @beiapp }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beiapp.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beiapps/1 or /beiapps/1.json
  def update
    respond_to do |format|
      if @beiapp.update(beiapp_params)
        format.html { redirect_to @beiapp, notice: 'Beiapp was successfully updated.' }
        format.json { render :show, status: :ok, location: @beiapp }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beiapp.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beiapps/1 or /beiapps/1.json
  def destroy
    @beiapp.destroy!

    respond_to do |format|
      format.html { redirect_to beiapps_url, notice: 'Beiapp was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue ActiveRecord::RecordNotDestroyed => e
    respond_to do |format|
      format.html { redirect_to beiapps_url, alert: "Could not delete: #{e.message}" }
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  private

  # Beiapps belonging to the current Beispace/user
  def current_beispace_beiapps
    if current_beispace_user.present?
      current_beispace_user.beiapps 
    else
      Beiapp.none
    end
  end

  def set_beiapp
    @beiapp = current_beispace_beiapps.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to beiapps_url, alert: 'Beiapp not found or access denied.' }
      format.json { head :not_found }
    end
  end

  def onboarding_for(beiapp)
    Onboarding.find_by(beiapp: beiapp) || Onboarding.new
  end

  def deployments_for(onboarding)
    Deployment.where(onboarding: onboarding).order(created_at: :desc)
  end

  def git_repos_list
    return [] unless cookies['git_repos_url'].present?

    begin
      JSON.parse(git_control_fetch_Git_Repos(cookies['git_repos_url']))
    rescue JSON::ParserError, StandardError => e
      Rails.logger.warn("Failed to parse git repos: #{e.message}")
      []
    end
  end

  def beiapp_params
    params.require(:beiapp).permit(
      :name,
      :beispace_id,              
      :application_stack,
      :code_stack,
      :code_stack_version,
      :primary_dependency_stack,
      :database_stack,
      :database_version,
      :summary,
      :owner_name,
      :owner_contact_phone,
      :owner_location,
      :owner_website,
      :owner_contact_email,
      :owner_social_twitter,
      :owner_social_github,
      :owner_social_instagram
    )
  end
end