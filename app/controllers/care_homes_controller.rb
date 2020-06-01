class CareHomesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :care_home_params, except: [:create, :claim]

  # GET /care_homes
  def index
    if(params[:search].present?)
      @care_homes = CareHome.search(params[:search]+"*")
    end
    render json: @care_homes.page(@page).per(@per_page) 
  end

  # GET /care_homes/1
  def show
    render json: @care_home
  end

  def claim
    UserNotifierMailer.claim_care_home(params[:care_home_id], current_user.id).deliver_later
    render json: {success: true}
  end
  
  def new_qr_code
    current_user.care_home.new_qr_code
    render json: current_user.care_home
  end

  # POST /care_homes
  def create
    @care_home = CareHome.new(care_home_params)

    if @care_home.save
      # We need to ensure that the user becomes the care_home admin when it is created
      if(@current_user.role == "Admin")
        @current_user.care_home_id = @care_home.id
        @current_user.save
      end
      render json: @care_home, status: :created, location: @care_home
    else
      render json: @care_home.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /care_homes/1
  def update
    if @care_home.update(care_home_params)
      render json: @care_home
    else
      render json: @care_home.errors, status: :unprocessable_entity
    end
  end

  # DELETE /care_homes/1
  def destroy
    @care_home.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_care_home
    @care_home = CareHome.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def care_home_params
    params.require(:care_home).permit(:name, :address, :town, :postcode, :base_rate, :phone,
      :image_url, :cqc_location, :bank_account, :sort_code, :accept_bank_transactions, :carer_break_mins,
      :vat_number, :company_registration_number, :parking_available,:paid_unpaid_breaks, :meals_provided_on_shift,
      :meals_subsidised, :dress_code, :po_req_for_invoice)
  end
end
