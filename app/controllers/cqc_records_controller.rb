class CqcRecordsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :cqc_record_params, except: [:index, :search_care_homes_and_cqc]

  respond_to :json

  def index
    @cqc_records = CqcRecord.search(params[:search]+"*", 
      :field_weights => {:name => 10, :address => 3})
    respond_with(@cqc_records)
  end


  def search_care_homes_and_cqc

    @care_homes = CareHome.search(params[:search]+"*", 
      :field_weights => {:name => 10, :address => 3}, :max_matches => 5)

    @cqc_records = CqcRecord.search(params[:search]+"*", 
      :field_weights => {:name => 10, :address => 3}, :max_matches => 5)

    respond_with( {care_homes: @care_homes, cqc_records: @cqc_records} )
  end

  def show
    respond_with(@cqc_record)
  end

  def new
    @cqc_record = CqcRecord.new
    respond_with(@cqc_record)
  end

  def edit
  end

  def create
    @cqc_record = CqcRecord.new(cqc_record_params)
    @cqc_record.save
    respond_with(@cqc_record)
  end

  def update
    @cqc_record.update(cqc_record_params)
    respond_with(@cqc_record)
  end

  def destroy
    @cqc_record.destroy
    respond_with(@cqc_record)
  end

  private
  def set_cqc_record
    @cqc_record = CqcRecord.find(params[:id])
  end

  def cqc_record_params
    params.require(:cqc_record).permit(:name, :aka, :address, :postcode, :phone, :website, :service_types, :services, :local_authority, :region, :cqc_url, :cqc_location)
  end
end
