class PaymentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :payment_params

  # GET /payments
  def index
    @payments = @payments.page(@page).per(@per_page)    
    render json: @payments.includes(:user, :care_home, :staffing_request), include: "user,care_home"
  end

  # GET /payments/1
  def show
    render json: @payment
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)
    @payment.paid_by_id = current_user.id
    @payment.care_home_id = current_user.care_home_id
    
    if @payment.save
      render json: @payment, status: :created, location: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payments/1
  def update
    if @payment.update(payment_params)
      render json: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payment_params
      params.require(:payment).permit(:shift_id, :staffing_request_id, :user_id, :care_home_id, :paid_by_id, :amount, :notes)
    end
end
