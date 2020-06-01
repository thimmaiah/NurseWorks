class ReferralsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :referral_params

  # GET /referrals
  def index
    @referrals = @referrals.page(@page).per(@per_page)
    render json: @referrals.includes(:user)
  end

  # GET /referrals/1
  def show
    render json: @referral
  end

  # POST /referrals
  def create
    @referral = Referral.new(referral_params)
    @referral.user_id = current_user.id

    if @referral.save
      render json: @referral, status: :created, location: @referral
    else
      render json: @referral.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /referrals/1
  def update
    if @referral.update(referral_params)
      render json: @referral
    else
      render json: @referral.errors, status: :unprocessable_entity
    end
  end

  # DELETE /referrals/1
  def destroy
    @referral.destroy
  end

  private
    def set_referral
      @referral = Referral.find(params[:id])
    end

    def referral_params
      params.require(:referral).permit(:first_name, :last_name, :email, :role, :user_id, :referral_status, :payment_status)
    end
end
