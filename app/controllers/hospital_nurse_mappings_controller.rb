class HospitalNurseMappingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :hospital_nurse_mapping_params

  def index
    @hospital_nurse_mappings = HospitalNurseMapping.all
    respond_with(@hospital_nurse_mappings)
  end

  def show
    respond_with(@hospital_nurse_mapping)
  end

  def new
    @hospital_nurse_mapping = HospitalNurseMapping.new
    respond_with(@hospital_nurse_mapping)
  end

  def edit
  end

  def create
    @hospital_nurse_mapping = HospitalNurseMapping.new(hospital_nurse_mapping_params)
    @hospital_nurse_mapping.save
    respond_with(@hospital_nurse_mapping)
  end

  def update
    @hospital_nurse_mapping.update(hospital_nurse_mapping_params)
    respond_with(@hospital_nurse_mapping)
  end

  def destroy
    @hospital_nurse_mapping.destroy
    respond_with(@hospital_nurse_mapping)
  end

  private
    def set_hospital_nurse_mapping
      @hospital_nurse_mapping = HospitalNurseMapping.find(params[:id])
    end

    def hospital_nurse_mapping_params
      params.require(:hospital_nurse_mapping).permit(:hospital_id, :user_id, :enabled, :distance, :manually_created)
    end
end
