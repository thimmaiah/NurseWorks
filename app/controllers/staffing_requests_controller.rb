class StaffingRequestsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :staffing_request_params

  # GET /staffing_requests
  def index
    @per_page = 100
    @staffing_requests = StaffingRequest.where(hospital_id: current_user.hospital_ids) if !@staffing_requests
    if(params[:recurring_request_id].present?)
      @staffing_requests = @staffing_requests.where(recurring_request_id: params[:recurring_request_id])
    end

    if params[:filterStartDate].present?
      @staffing_requests = @staffing_requests.where("start_date >= ?", params[:filterStartDate]) 
    end
    if params[:filterEndDate].present?
      @staffing_requests = @staffing_requests.where("end_date <= ?", params[:filterEndDate]) 
    end

    @staffing_requests = @staffing_requests.open.order("staffing_requests.start_date asc").page(@page).per(@per_page)
    #@staffing_requests = @staffing_requests.joins(:user, :hospital)
    render json: @staffing_requests.includes(:hospital), include: "hospital", each_serializer: StaffingRequestMiniSerializer
  end

  def get_nurses
    @staffing_request = StaffingRequest.new(staffing_request_params)
    if @staffing_request.staff_type == "Temp"
      nurses = @staffing_request.hospital.temp_nurses.where(pause_shifts: false)
    else
      nurses = @staffing_request.hospital.perm_nurses
    end
    render json: nurses, each_serializer: UserMiniSerializer
  end


  def price
    @staffing_request = StaffingRequest.new(staffing_request_params)
    @staffing_request.user_id = current_user.id
    @staffing_request.hospital_id = current_user.hospital_id
    @staffing_request.created_at = Time.now if !@staffing_request.created_at

    Rate.price_estimate(@staffing_request)
    render json: @staffing_request
  end


  # GET /staffing_requests/1
  def show
    render json: @staffing_request
  end


  # POST /staffing_requests
  def create
    @staffing_request = StaffingRequest.new(staffing_request_params)
    @staffing_request.user_id = current_user.id
    @staffing_request.nurse_break_mins = current_user.hospital.nurse_break_mins if staffing_request_params["nurse_break_mins"] == nil

    # Sometimes we get requests with care home - where 1 person manages multiple care homes
    if(@staffing_request.hospital_id)
      # Make sure we can book a req for this care home, if its not a sister care home - deny access
      raise CanCan::AccessDenied unless current_user.belongs_to_hospital(@staffing_request.hospital_id)
    else
      @staffing_request.hospital_id = current_user.hospital_id
    end

    if @staffing_request.save
      render json: @staffing_request, status: :created, location: @staffing_request
    else
      render json: @staffing_request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /staffing_requests/1
  def update
    if @staffing_request.update(staffing_request_params)
      render json: @staffing_request
    else
      render json: @staffing_request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /staffing_requests/1
  def destroy
    @staffing_request.request_status = "Cancelled"
    @staffing_request.save
    UserNotifierMailer.request_cancelled(@staffing_request).deliver_later      
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_staffing_request
    @staffing_request = StaffingRequest.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def staffing_request_params
    
    params.require(:staffing_request).permit(:hospital_id, :user_id, :start_date, :manual_assignment_flag, :notes,
                                             :shift_duration, :rate_per_hour, :request_status, :auto_deny_in, :response_count,
                                             :payment_status, :start_code, :end_code, :price, :role, :speciality, :reason, 
                                             :preferred_nurse_id, :po_for_invoice, :staff_type,
                                             :pricing_audit=>[:hours_worked, :base_rate, :base_price, :factor_value, :factor_name, :price]
                                             )
  end
end
