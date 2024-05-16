# frozen_string_literal: true

class BeispacesController < ApplicationController
  before_action :set_beispace, only: %i[index show edit update destroy]
  before_action :stage_beispace

  # GET /beispaces or /beispaces.json
  def index
    # @beispaces = Beispace.all
    p @beispace
  end

  # GET /beispaces/1 or /beispaces/1.json
  def show
     @beispace
  end

  # GET /beispaces/new
  def new
    @beispace = Beispace.new
  end

  # GET /beispaces/1/edit
  def edit; end

  # POST /beispaces or /beispaces.json
  def create
    @beispace = Beispace.new(beispace_params)

    respond_to do |format|
      if @beispace.save
        format.html { redirect_to beispace_url(@beispace), notice: 'Beispace was successfully created.' }
        format.json { render :show, status: :created, location: @beispace }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beispace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beispaces/1 or /beispaces/1.json
  def update
    respond_to do |format|
      if @beispace.update(beispace_params)
        format.html { redirect_to beispace_url(@beispace), notice: 'Beispace was successfully updated.' }
        format.json { render :show, status: :ok, location: @beispace }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beispace.errors, status: :unprocessable_entity }
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

  # Use callbacks to share common setup or constraints between actions.
  def set_beispace
    @beispace = [{ id: cookies['beispace'] }]
    p @beispace
  end

  # Only allow a list of trusted parameters through.
  def beispace_params
    params.require(:beispace).permit(:user_id, :subdomain, :designation, :app_count)
  end

  def stage_beispace
    p 'stage_beispace---stage_beispace'
    return unless @beispace

    redirect_to beispace_path(@beispace)
  end
end
