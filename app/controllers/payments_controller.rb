class PaymentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :payment_params

  # GET /payments
  def index
    @payments = @payments.page(@page).per(@per_page)    
    render json: @payments.includes(:user, :hospital, :staffing_request), include: "user,hospital"
  end

  # GET /payments/1
  def show
    render json: @payment
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)
    @payment.paid_by_id = current_user.id
    @payment.hospital_id = current_user.hospital_id
    
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
      params.require(:payment).permit(:shift_id, :staffing_request_id, :user_id, :hospital_id, :paid_by_id, :amount, :notes)
    end
end
