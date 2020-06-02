class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :nurse_type, 
  :sex, :title, :phone, :phone_verified, :address, :postcode, :languages, :pref_commute_distance, 
  :speciality, :experience, :referal_code, :accept_terms, :hospital_id, :hospital_ids, :sister_hospitals,
  :image, :can_manage, :verified, :sort_code, :bank_account, :rating, :user_docs, :push_token,
  :accept_bank_transactions, :accept_bank_transactions_date, :sms_verification_code, :hospital_agencies,
  :work_weekdays, :work_weeknights, :work_weekends, :work_weekend_nights, :pause_shifts, :medical_info,
  :password_reset_date

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
