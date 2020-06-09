class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :nurse_type, 
  :sex, :title, :phone, :phone_verified, :address, :city, :lat, :lng, :languages, :pref_commute_distance, 
  :specializations, :referal_code, :accept_terms, :hospital_id, :hospital_ids, :sister_hospitals,
  :image, :can_manage, :verified, :sort_code, :bank_account, :rating, :user_docs, :push_token,
  :sms_verification_code, :avail_part_time, :pref_shift_duration, :pref_shift_time, :exp_shift_rate,
  :work_weekdays, :work_weeknights, :work_weekends, :work_weekend_nights, :pause_shifts, :medical_info,
  :password_reset_date, :age, :years_of_exp, :months_of_exp, :key_qualifications, :avail_part_time,
  :shifts_per_month, :nursing_school_name, :NUID, :head_nurse, :conveyence, :public_profile, :avail_full_time 

  has_many :user_docs, serializer: UserDocSerializer
  belongs_to :hospital, serializer: HospitalSerializer

  def can_manage
  	Ability.new(scope).can?(:manage, object)
  end

  def user_docs
    object.user_docs.not_expired
  end

  def sister_hospitals
    object.hospitals if object.hospital && object.hospital.sister_hospitals
  end

end
