class ProfilesController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource param_method:  :profile_params

  respond_to :json

  def index
    @profiles = Profile.all
    respond_with(@profiles)
  end

  def show
    respond_with(@profile)
  end

  def new
    @profile = Profile.new
    respond_with(@profile)
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.save
    respond_with(@profile)
  end

  def update
    @profile.update(profile_params)
    respond_with(@profile)
  end

  def destroy
    @profile.destroy
    respond_with(@profile)
  end

  private
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:user_id, :date_of_CRB_DBS_check, :dob, :pin, :enhanced_crb, :crd_dbs_returned, :isa_returned, :crd_dbs_number, :eligible_to_work_UK, :confirmation_of_identity, :references_received, :dl_passport, :all_required_paperwork_checked, :registered_under_disability_act, :connuct_policies, :form_completed_by, :position, :date_sent, :date_received, :known_as, :role)
    end
end
