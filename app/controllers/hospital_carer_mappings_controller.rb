class HospitalCarerMappingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :hospital_carer_mapping_params

  def index
    @hospital_carer_mappings = HospitalCarerMapping.all
    respond_with(@hospital_carer_mappings)
  end

  def show
    respond_with(@hospital_carer_mapping)
  end

  def new
    @hospital_carer_mapping = HospitalCarerMapping.new
    respond_with(@hospital_carer_mapping)
  end

  def edit
  end

  def create
    @hospital_carer_mapping = HospitalCarerMapping.new(hospital_carer_mapping_params)
    @hospital_carer_mapping.save
    respond_with(@hospital_carer_mapping)
  end

  def update
    @hospital_carer_mapping.update(hospital_carer_mapping_params)
    respond_with(@hospital_carer_mapping)
  end

  def destroy
    @hospital_carer_mapping.destroy
    respond_with(@hospital_carer_mapping)
  end

  private
    def set_hospital_carer_mapping
      @hospital_carer_mapping = HospitalCarerMapping.find(params[:id])
    end

    def hospital_carer_mapping_params
      params.require(:hospital_carer_mapping).permit(:hospital_id, :user_id, :enabled, :distance, :manually_created)
    end
end
