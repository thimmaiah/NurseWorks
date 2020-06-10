class HospitalsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :hospital_params, except: [:create, :claim]

  # GET /hospitals
  def index
    if(params[:search].present?)
      @hospitals = Hospital.search(params[:search]+"*")
    end
    render json: @hospitals.page(@page).per(@per_page) 
  end

  # GET /hospitals/1
  def show
    render json: @hospital
  end

  def claim
    UserNotifierMailer.claim_hospital(params[:hospital_id], current_user.id).deliver_later
    render json: {success: true}
  end
  
  # POST /hospitals
  def create
    @hospital = Hospital.new(hospital_params)

    if @hospital.save
      # We need to ensure that the user becomes the hospital admin when it is created
      if(@current_user.role == "Admin")
        @current_user.hospital_id = @hospital.id
        @current_user.save
      end
      render json: @hospital, status: :created, location: @hospital
    else
      render json: @hospital.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /hospitals/1
  def update
    if @hospital.update(hospital_params)
      render json: @hospital
    else
      render json: @hospital.errors, status: :unprocessable_entity
    end
  end

  # DELETE /hospitals/1
  def destroy
    @hospital.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_hospital
    @hospital = Hospital.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def hospital_params
    params.require(:hospital).permit(:name, :address, :town, :phone,
      :image_url, :city, :bank_account, :accept_bank_transactions, :nurse_break_mins,
      :vat_number, :company_registration_number, :parking_available,:paid_unpaid_breaks, :meals_provided_on_shift,
      :meals_subsidised, :dress_code, :po_req_for_invoice, :num_of_beds,  :nurse_count,
      :typical_workex, :owner_name, specializations:[])
  end
end
