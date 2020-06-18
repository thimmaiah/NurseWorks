ThinkingSphinx::Index.define :staffing_request, :with => :real_time do
  # fields
  indexes hospital.name, :as => :hospital_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true

  # attributes
  has hospital_id,  :type => :integer
  has user_id,  :type => :integer
  has request_status, :type=>:string
  has broadcast_status, :type=>:string
  has shift_status, :type=>:string
  has manual_assignment_flag, :type=>:boolean
end

ThinkingSphinx::Index.define :hospital, :with => :real_time do
  # fields
  indexes name
  indexes phone
  indexes specializations
  has city, :type=>:string
  has verified, :type=>:boolean
  has latitude_in_radians, as: :latitude, type: :float
  has longitude_in_radians, as: :longitude, type: :float
end

ThinkingSphinx::Index.define :lesson, :with => :real_time do
  # fields
  indexes title
  indexes description
  indexes link_type
  indexes key_qualifications
  indexes specializations
end

ThinkingSphinx::Index.define :referral, :with => :real_time do
  # fields
  indexes first_name
  indexes last_name
  indexes email
  has referral_status, :type=>:string
  has payment_status, :type=>:string
end

ThinkingSphinx::Index.define :contact, :with => :real_time do
  # fields
  indexes name
  indexes phone
  indexes email
  indexes user.first_name
  indexes user.last_name
end


ThinkingSphinx::Index.define :user, :with => :real_time do
  # fields
  indexes first_name
  indexes email
  indexes last_name
  indexes city
  indexes specializations
  indexes key_qualifications
  indexex phone

  # attributes
  has latitude_in_radians, as: :latitude, type: :float
  has longitude_in_radians, as: :longitude, type: :float
  has verified, :type=>:boolean
  has phone_verified, :type=>:boolean
  has active, :type=>:boolean
  has avail_part_time, :type=>:boolean
  has avail_full_time, :type=>:boolean
  has public_profile, :type=>:boolean
  has currently_permanent_staff, :type=>:boolean
  has role, :type=>:string
  has auto_selected_date, :type => :timestamp
  has years_of_exp, :type=>:integer
end



ThinkingSphinx::Index.define :rating, :with => :real_time do
  # fields
  indexes comments
  indexes hospital.name, :as => :hospital_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true

  has user_id,  :type => :integer
  has hospital_id,  :type => :integer
  has stars,  :type => :integer
end

ThinkingSphinx::Index.define :payment, :with => :real_time do
  # fields
  indexes hospital.name, :as => :hospital_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true
  indexes notes

  has user_id,  :type => :integer
  has hospital_id,  :type => :integer
  has amount,  :type => :float
end


ThinkingSphinx::Index.define :user_doc, :with => :real_time do
  # fields
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true
  indexes :name  
  indexes doc_type

  has user_id,  :type => :integer
end

ThinkingSphinx::Index.define :school, :with => :real_time do
  # fields
  indexes :name  
  indexes address
end


ThinkingSphinx::Index.define :shift, :with => :real_time do
  # fields
  indexes hospital.name, :as => :hospital_name, :sortable => true
  indexes user.first_name, :as => :user_first_name, :sortable => true
  indexes user.last_name, :as => :user_last_name, :sortable => true  

  
  has user_id,  :type => :integer
  has hospital_id,  :type => :integer
  has rated,  :type => :boolean
  has accepted,  :type => :boolean
  has response_status, :type => :string
  has payment_status, :type => :string
  has hospital_payment_status, :type => :string
  has start_code, :type => :string
  has end_code, :type => :string
end