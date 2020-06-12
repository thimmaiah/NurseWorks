class ShiftsController < ApplicationController
  
  before_action :authenticate_user!, 
            :except => [:reject_anonymously]

  load_and_authorize_resource param_method: :shift_params, 
            :except => [:reject_anonymously]

  # GET /shifts
  def index

    @shifts = Shift.where(hospital_id: current_user.hospital_ids) if current_user.hospital_id && !@shifts

    if (params[:staffing_request_id].present?)
        @shifts = @shifts.where(staffing_request_id: params[:staffing_request_id])
    end

    if(params[:response_status].present?)
      @shifts = @shifts.where(response_status: params[:response_status])
    else
      @shifts = @shifts.open
    end

    @per_page = 100
    @shifts = @shifts.joins(:staffing_request)
    @shifts = @shifts.order("staffing_requests.start_date asc").page(@page).per(@per_page)
    render json: @shifts.includes(:staffing_request, :hospital, :user=>:profile_pic), 
                                  include: "user,hospital", 
                                  each_serializer: ShiftMiniSerializer

  end



  # This is called by the UI when the nurse accepts/rejects the shift assigned to him
  def update_response
    if @shift.update_response(params[:response_status], params[:reason])    
      render json: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # GET /shifts/1
  def show

    if(current_user.id == @shift.user_id && !@shift.viewed)
      # Mark this as viewed if the care giver assigned, has seen it
      @shift.viewed = true 
      @shift.save
    end
    
    render json: @shift
  end

  # POST /shifts
  def create
    @shift = Shift.new(shift_params)
    @shift.user_id = current_user.id

    if @shift.save
      render json: @shift, status: :created, location: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shifts/1
  def update
    if @shift.update(shift_params)
      render json: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shifts/1
  def destroy
    @shift.response_status = "Cancelled"
    @shift.save
  end

  def reject_anonymously
    @shift = Shift.find(params[:id])
    if (params[:hash] == @shift.generate_anonymous_reject_hash)
      @shift.response_status = "Rejected"
      @shift.save
      redirect_to "http://blog.nurse_works.co.uk/unsubscribe?rejected=true"
    else
      redirect_to "http://blog.nurse_works.co.uk/unsubscribe?rejected=failed"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shift_params
      params.require(:shift).permit(:staffing_request_id, :user_id, :start_code, :reason,
        :end_code, :response_status, :accepted, :rated, :hospital_id, :payment_status)
    end
end
