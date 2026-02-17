# frozen_string_literal: true

class BeispacesController < ApplicationController
  before_action :authenticate_user! , except: %i[new create]
  before_action :set_current_beispace, only: %i[index show edit update destroy]
  before_action :set_beispace,         only: %i[show edit update destroy]

  # GET /beispaces or /beispaces.json
  def index
    @beispaces = current_user_beispaces 
  end

  # GET /beispaces/1 or /beispaces/1.json
  def show

  end

  # GET /beispaces/new
  def new
    @beispace = Beispace.new
  end

  # GET /beispaces/1/edit
  def edit; end

  # POST /beispaces or /beispaces.json
  def create
    @beispace = current_user_beispaces.build(beispace_params)

    respond_to do |format|
      if @beispace.save
        # After creation → set as current Beispace (common pattern)
        cookies['beispace'] = @beispace.id.to_s
        format.html { redirect_to @beispace, notice: 'Beispace was successfully created.' }
        format.json { render :show, status: :created, location: @beispace }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beispace.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beispaces/1 or /beispaces/1.json
  def update
    respond_to do |format|
      if @beispace.update(beispace_params)
        format.html { redirect_to @beispace, notice: 'Beispace was successfully updated.' }
        format.json { render :show, status: :ok, location: @beispace }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beispace.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beispaces/1 or /beispaces/1.json
  def destroy
    @beispace.destroy

    respond_to do |format|
      format.html { redirect_to beispaces_url, notice: 'Beispace was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Returns Beispaces the current authenticated user has access to
  # (assuming Beispace belongs_to :user or has_many :users through memberships)
  def current_user_beispaces
    if current_beispace_user.present?
      current_beispace_user.beispaces
    else
      Beispace.none
    end
  end

  # Sets @current_beispace from cookie — used for context / redirect logic
  def set_current_beispace
    beispace_id = cookies['beispace']

    if beispace_id.present?
      @current_beispace = current_user_beispaces.find_by(id: beispace_id)
    end

    # Fallback: if no valid current → redirect to index or selection page
    redirect_to beispaces_path, alert: 'Please select a Beispace.' unless @current_beispace || action_name.in?(%w[index new create])
  end

  # Loads the specific Beispace for actions that need it — scoped to user's Beispaces
  def set_beispace
    @beispace = current_user_beispaces.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to beispaces_url, alert: 'Beispace not found or access denied.' }
      format.json { head :not_found }
    end
  end

  def beispace_params
    params.require(:beispace).permit(
      :subdomain,
      :designation,
      :app_count
    )
  end
end