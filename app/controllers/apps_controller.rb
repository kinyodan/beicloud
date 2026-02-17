# frozen_string_literal: true

class AppsController < ApplicationController
  before_action :set_app, only: %i[show edit update destroy]

  # GET /apps or /apps.json
  def index
    @pagy, @apps = pagy(current_user_apps, items: 20, page: params[:page])
  end

  # GET /apps/1 or /apps/1.json
  def show
    # Authorization check should go here (see notes below)
  end

  # GET /apps/new
  def new
    @app = App.new
  end

  # GET /apps/1/edit
  def edit; end

  # POST /apps or /apps.json
  def create
    @app = current_user_apps.build(app_params)

    respond_to do |format|
      if @app.save
        format.html { redirect_to @app, notice: "App was successfully created." }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apps/1 or /apps/1.json
  def update
    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to @app, notice: "App was successfully updated." }
        format.json { render :show, status: :ok, location: @app }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1 or /apps/1.json
  def destroy
    @app.destroy

    respond_to do |format|
      format.html { redirect_to apps_url, notice: "App was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_app
    @app = current_user_apps.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to apps_url, alert: "App not found." }
      format.json { head :not_found }
    end
  end

  def current_user_apps
    if current_beispace_user.present?
      current_beispace_user.apps
    else
      App.none
    end
  end

  def app_params
    params.require(:app).permit(
      :subdomain,
      :anchor_url,
      :back_up_url,
      :main_url,
      :github_account,
      :github_repo_name,
      :github_owner,
      :status,
      :app_dashboard_id
    )
  end
end