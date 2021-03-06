class UsersController < ApplicationController

  before_action :authenticate_user!, 
    except: [ :unsubscribe, :resend_confirmation, :reset_password, 
              :generate_reset_password_by_sms, :reset_password_by_sms ]
  load_and_authorize_resource param_method: :user_params,
    except: [ :unsubscribe, :send_sms_verification, :verify_sms_verification, :resend_confirmation, 
              :reset_password, :generate_reset_password_by_sms, :reset_password_by_sms ]

  # GET /users
  def index
    @users = User.spx_verified(true).spx_public_profile(true)
    
    if(params[:key_qualifications].present?)
      @users = @users.spx_key_qualifications(Riddle::Query.escape(params[:key_qualifications]))
    end

    if(params[:specializations].present?)
      @users = @users.spx_specializations(Riddle::Query.escape(params[:specializations]))
    end

    if(params[:city].present?)
      @users = @users.spx_city(Riddle::Query.escape(params[:city]))
    end

    if(params[:experience].present?)
      @users = @users.spx_experience(eval(params[:experience]))
    end

    if(params[:availability].present?)
      if(params[:availability] == 'Full Time')
        @users = @users.spx_avail_full_time(true)
      elsif (params[:availability] == 'Part Time')
        @users = @users.spx_avail_part_time(true)
      end
      
    end

    render json: @users.search
  end

  # GET /users/1
  def show
    render json: @user
  end


  def get_nurses
    if params[:staff_type] == "Temp"
      nurses = current_user.hospital.temp_nurses.where(pause_shifts: false)
    elsif params[:staff_type] == "Perm"
      nurses = current_user.hospital.perm_nurses
    end
    render json: nurses, each_serializer: UserMiniSerializer
  end


  def get_initial_data
    resp = {}
    if current_user.is_temp?
      resp["pending"] = current_user.shifts.pending.count
      resp["accepted"] = current_user.shifts.accepted.count
    elsif current_user.is_admin? && current_user.hospital
    end

    render json: resp
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    logger.debug "### #{params[:user][:part_time_work_days]}"
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  def delete_requested
    @user.active = false
    @user.delete_requested = true
    if @user.save
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def unsubscribe
    user = User.find_by_unsubscribe_hash(params[:unsubscribe_hash])
    if(user)
      Rails.logger.info "unsubscribe called for #{user.email}"
      user.update_attribute(:subscription, false)
    end
    redirect_to ENV['REDIRECT_UNSUBSCRIBE']
  end

  def send_sms_verification
    current_user.send_sms_verification()
  end

  def verify_sms_verification
    if current_user.confirm_sms_verification(params[:code])
      render json: {verified: true}
    else
      render json: {verified: false}
    end
  end

  def resend_confirmation
    user = User.find_by_email(params[:email])
    if(user)
      user.send_confirmation_instructions
      render json: {sent: true}
    else
      render json: {sent: false, user_not_found: true}
    end
  end

  def reset_password
    user = User.find_by_reset_password_token(params[:token])
    if(user)
      user.password = params[:password]
      user.save
      render json: {reset: true}
    else
      render json: {reset: false}
    end
  end

  def generate_reset_password_by_sms
    user = User.find_by_email(params[:email])
    if(user)
      user.generate_password_reset_code
      render json: {reset: true}
    else
      render json: {reset: false, user_not_found: true}
    end
  end

  def reset_password_by_sms        
    if( User.try_password_reset_code(params[:email], params[:password_reset_code], params[:password]) )
      render json: {reset: true}
    else
      render json: {reset: false}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :nurse_type,
                                 :sex, :title, :address, :city, :lat, :lng, :phone, :languages, 
                                 :pref_commute_distance,  
                                 :referal_code, :accept_terms, :hospital_id, :image_url, :verified,
                                 :active, :bank_account, :payment_option, :upi, :push_token, :medical_info, 
                                 :nursing_school_name, :head_nurse,
                                 :work_weekdays, :work_weeknights, :work_weekends, 
                                 :work_weekend_nights, :pause_shifts, :age, :years_of_exp, 
                                 :months_of_exp,:key_qualifications, 
                                 :avail_part_time, :shifts_per_month, :conveyence, :pref_shift_duration, 
                                 :pref_shift_time, 
                                 :exp_shift_rate, :public_profile, :avail_full_time, 
                                 :currently_permanent_staff, :NUID, 
                                 specializations: [], part_time_work_days: [])
  end
end
