class OnboardingsController < ApplicationController
  before_action :set_onboarding, only: %i[ show edit update destroy ]

  # GET /onboardings or /onboardings.json
  def index
    @onboardings = Onboarding.all
  end

  # GET /onboardings/1 or /onboardings/1.json
  def show
    token = "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"
    owner = "kinyodan"
    repo = "beimarket-v1"
    path_to_file = ""
    retreived_repos = onboardingServiceImportFromGithub(token,owner,repo,path_to_file )
    if retreived_repos
      @repos = retreived_repos
    else
      @repos = []
    end 

  end

  # GET /onboardings/new
  def new
    @onboarding = Onboarding.new
  end

  # GET /onboardings/1/edit
  def edit
  end

  # POST /onboardings or /onboardings.json
  def create
    @onboarding = Onboarding.new(onboarding_params)

    respond_to do |format|
      if @onboarding.save
        format.html { redirect_to onboarding_url(@onboarding), notice: "Onboarding was successfully created." }
        format.json { render :show, status: :created, location: @onboarding }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @onboarding.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /onboardings/1 or /onboardings/1.json
  def update
    respond_to do |format|
      if @onboarding.update(onboarding_params)
        format.html { redirect_to onboarding_url(@onboarding), notice: "Onboarding was successfully updated." }
        format.json { render :show, status: :ok, location: @onboarding }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @onboarding.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /onboardings/1 or /onboardings/1.json
  def destroy
    @onboarding.destroy

    respond_to do |format|
      format.html { redirect_to onboardings_url, notice: "Onboarding was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_onboarding
      @onboarding = Onboarding.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def onboarding_params
      params.require(:onboarding).permit(:user_id, :subdomain, :uuid, :status, :state)
    end
end
