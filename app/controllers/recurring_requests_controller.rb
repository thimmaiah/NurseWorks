class RecurringRequestsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :recurring_request_params, except: [:create]

  respond_to :json

  def index
    @per_page = 10
    @recurring_requests = RecurringRequest.where(hospital_id: current_user.hospital_ids) if !@recurring_requests
    @recurring_requests = @recurring_requests.order("recurring_requests.start_date asc").page(@page).per(@per_page)
    
    render json:  @recurring_requests.includes(:hospital, :user)
  end

  def get_nurses
    @recurring_request = RecurringRequest.new(recurring_request_params)
    if @recurring_request.staff_type == "Temp"
      nurses = @recurring_request.hospital.temp_nurses.where(pause_shifts: false)
    else
      nurses = @recurring_request.hospital.perm_nurses
    end
    render json: nurses, each_serializer: UserMiniSerializer
  end


  def show
    respond_with(@recurring_request)
  end

  def new
    @recurring_request = RecurringRequest.new
    respond_with(@recurring_request)
  end

  def edit
  end

  def create
    @recurring_request = RecurringRequest.new(recurring_request_params)
    @recurring_request.user_id = current_user.id
    @recurring_request.save
    respond_with(@recurring_request)
  end

  def update
    @recurring_request.update(recurring_request_params)
    respond_with(@recurring_request)
  end

  def destroy
    @recurring_request.destroy
    respond_with(@recurring_request)
  end

  private
    def set_recurring_request
      @recurring_request = RecurringRequest.find(params[:id])
    end

    def recurring_request_params
      params.require(:recurring_request).permit(:hospital_id, :user_id, :start_date, 
          :end_date, :role, :po_for_invoice, :shift_duration, :staff_type,
          :speciality, :on, :start_on, :end_on, 
          :audit, {dates:[]}, :notes, :preferred_nurse_id)
    end
end
