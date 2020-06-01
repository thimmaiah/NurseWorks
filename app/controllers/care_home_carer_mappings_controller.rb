class CareHomeCarerMappingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :care_home_carer_mapping_params

  def index
    @care_home_carer_mappings = CareHomeCarerMapping.all
    respond_with(@care_home_carer_mappings)
  end

  def show
    respond_with(@care_home_carer_mapping)
  end

  def new
    @care_home_carer_mapping = CareHomeCarerMapping.new
    respond_with(@care_home_carer_mapping)
  end

  def edit
  end

  def create
    @care_home_carer_mapping = CareHomeCarerMapping.new(care_home_carer_mapping_params)
    @care_home_carer_mapping.save
    respond_with(@care_home_carer_mapping)
  end

  def update
    @care_home_carer_mapping.update(care_home_carer_mapping_params)
    respond_with(@care_home_carer_mapping)
  end

  def destroy
    @care_home_carer_mapping.destroy
    respond_with(@care_home_carer_mapping)
  end

  private
    def set_care_home_carer_mapping
      @care_home_carer_mapping = CareHomeCarerMapping.find(params[:id])
    end

    def care_home_carer_mapping_params
      params.require(:care_home_carer_mapping).permit(:care_home_id, :user_id, :enabled, :distance, :manually_created)
    end
end
