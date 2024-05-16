# frozen_string_literal: true

class BeiappsController < ApplicationController
  include GitControlService
  before_action :set_beiapp, only: %i[show edit update destroy]

  # GET /beiapps or /beiapps.json
  def index
    add_breadcrumb 'index', beiapps_path
    @beiapps = Beiapp.all
  end

  # GET /beiapps/1 or /beiapps/1.json
  def show
    add_breadcrumb 'index', beiapp_path
    @onboarding = get_onboarding(@beiapp.id)

    # @beiapp = Beiapp.where(id: @onboarding.beiapp_id).first
    @deployments = get_deployment(@onboarding.id)
    @repos = get_repos_list
    @repos_list = respo_list_setup(@repos)

    gon.push(repos: @repos_list)
  end

  # GET /beiapps/new
  def new
    @beiapp = Beiapp.new
  end

  # GET /beiapps/1/edit
  def edit; end

  # POST /beiapps or /beiapps.json
  def create
    @beiapp = Beiapp.new(beiapp_params)

    respond_to do |format|
      if @beiapp.save
        format.html { redirect_to beiapp_url(@beiapp), notice: 'Beiapp was successfully created.' }
        format.json { render :show, status: :created, location: @beiapp }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beiapp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beiapps/1 or /beiapps/1.json
  def update
    respond_to do |format|
      if @beiapp.update(beiapp_params)
        format.html { redirect_to beiapp_url(@beiapp), notice: 'Beiapp was successfully updated.' }
        format.json { render :show, status: :ok, location: @beiapp }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beiapp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beiapps/1 or /beiapps/1.json
  def destroy
    @beiapp.destroy

    respond_to do |format|
      format.html { redirect_to beiapps_url, notice: 'Beiapp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def get_repos_list
    if request.cookies['git_repos_url']
      JSON.parse(git_control_fetch_Git_Repos(request.cookies['git_repos_url']))
    else
      []
    end
  end

  def respo_list_setup(repos)
    repos_list = []
    repos.each do |repo|
      repos_list.push(repo['name'])
    end
    return repos_list
  end 

  def get_onboarding(beiapp_id)
    Onboarding.where(beiapp_id: @beiapp.id).first
  end 

  def get_deployment(onboarding_id)
    Deployment.where(onboarding_id: @onboarding.id)
  end 
  # Use callbacks to share common setup or constraints between actions.
  def set_beiapp
    @beiapp = Beiapp.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def beiapp_params
    params.require(:beiapp).permit(:name, :beispace_id, :application_stack, :code_stack, :code_stack_version,
                                   :primary_dependency_stack, :database_stack, :database_version, :summary, :owner_name, :owner_contact_phone, :owner_location, :owner_website, :owner_contact_email, :owner_social_twitter, :owner_social_github, :owner_social_instagram)
  end
end
