require "application_responder"

class ApplicationController < ActionController::API
  
  # Devise stuff
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  # Authorization
  include CanCan::ControllerAdditions
  include ActionController::MimeResponds  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
    end
  end

  rescue_from Exception do |exception|
    respond_to do |format|
      Rails.logger.error "Caught exception #{exception}"
      format.json { render :json => exception.message, :status => 500 }
    end
  end

  # Required to enable additional user fields in registration
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :email, :role, :nurse_type,
    :sex, :title, :address, :city, :lat, :lng, :phone, :languages, :pref_commute_distance,  
    :referal_code, :accept_terms, :hospital_id, :image_url, :verified,
    :active, :bank_account, :push_token, :medical_info, :nursing_school_name, :NUID, :head_nurse,
    :accept_bank_transactions, :work_weekdays, :work_weeknights, :work_weekends, 
    :work_weekend_nights, :pause_shifts, :age, :years_of_exp, :months_of_exp, :key_qualifications, 
    :avail_part_time, :shifts_per_month, :conveyence, :pref_shift_duration, :pref_shift_time, 
    :exp_shift_rate, :public_profile, :avail_full_time, :currently_permanent_staff, 
    :part_time_work_days, specializations: [] ])
  end

  before_action :set_paper_trail_whodunnit
  def set_paper_trail_whodunnit
    PaperTrail.request.whodunnit = current_user.id if current_user
  end

  # Exception handling via email notification
  before_action :prepare_exception_notifier
  private
  def prepare_exception_notifier
    if current_user
      request.env["exception_notifier.exception_data"] = {
        :current_user => current_user
      }
    end

    logger.debug "uid = #{request.headers['uid']}, access-token = #{request.headers['access-token']}, client = #{request.headers['client']}"
  end

  before_action :setup_pagination, only: [:index]

  def setup_pagination
    @page = params[:page].present? ? params[:page] : 1
    @per_page = params[:per_page].present? ? params[:per_page] : 10
    logger.debug("page=#{@page}, per_page=#{@per_page}")
  end
  
end
