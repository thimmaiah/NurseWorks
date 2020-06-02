class HospitalSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :town, :postcode, :base_rate, :phone,
    :can_manage, :image_url, :verified, :bank_account, 
    :vat_number, :company_registration_number, :parking_available,
    :paid_unpaid_breaks, :meals_provided_on_shift,
    :meals_subsidised, :dress_code, :po_req_for_invoice, :carer_break_mins,
    :num_of_beds,  :nurse_count,
    :typical_workex, :owner_name, :specializations
    
  def can_manage
    Ability.new(scope).can?(:manage, object)
  end

end
