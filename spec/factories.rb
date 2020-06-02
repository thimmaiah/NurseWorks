include ActionDispatch::TestProcess

FactoryGirl.define do
  
  factory :hospital_carer_mapping do
    hospital_id 1
    user_id 1
    enabled false
    distance 1.5
    manually_created false
  end
  
  factory :recurring_request do
    start_date {Date.today.beginning_of_week + 2.hours}
    end_date {Date.today.beginning_of_week + 8.hours}
    role {["Nurse", "Care Giver"][rand(2)]}
    on "1,3,5"
    start_on {start_date}
    end_on {start_on + 2.weeks - 1.day}
  end

  
  factory :training do
    name {Faker::Company.bs}
    undertaken true
    date_completed {Date.today - rand(5).months}
    expiry_date {Date.today + rand(12).months}
    vendor {Faker::Company.name}
  end

  factory :profile do
    date_of_CRB_DBS_check {Date.today - rand(10).months}
    dob {Date.today - 20.years - rand(20).years}
    pin ""
    enhanced_crb true
    crd_dbs_returned true
    isa_returned true
    crd_dbs_number {rand.to_s[2..10]}
    eligible_to_work_UK true
    confirmation_of_identity true
    references_received {Date.today - 10.days}
    dl_passport true
    all_required_paperwork_checked true
    registered_under_disability_act false
    nurse_works_policies true
    form_completed_by "Naomi"
    date_sent {Date.today - 2.days}
    date_received {Date.today - 5.days}
    position "Business Consultant"
  end

  factory :referral do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    role "MyString"
    user_id 1
  end
  
  factory :holiday do
    name "MyString"
    date "2017-05-23"
    bank_holiday false
  end


  factory :rate do
    zone "North"
    role "Care Giver"
    carer_weekday 9
    hospital_weekday 11
    carer_weeknight 11
    hospital_weeknight 14
    carer_weekend 11
    hospital_weekend 13
    carer_weekend_night 12
    hospital_weekend_night 15
    carer_bank_holiday 14
    hospital_bank_holiday 20    
  end

  factory :rating do
    stars {rand(4) + 1}
    comments {Rating::COMMENTS[rand(Rating::COMMENTS.length)]}
  end

  factory :payment do
    shift_id 1
    user_id 1
    hospital_id 1
    paid_by_id 1
    amount 100
    notes "Thanks for your service"
  end

  factory :shift do
    accepted false
    rated false
  end

  factory :staffing_request do
    start_date {Date.today + 1.day + rand(6).hours}
    end_date {start_date + 8.hours}
    rate_per_hour 15
    request_status {"Open"}
    auto_deny_in 12
    response_count 0
    role {["Nurse", "Care Giver"][rand(2)]}
    payment_status {"Unpaid"}
    start_code {rand.to_s[2..6]}
    end_code {rand.to_s[2..6]}
    created_at {Time.now - 1.day}
    updated_at {Time.now - 1.day}
  end

  factory :hospital do

    logos = ["http://www.brandsoftheworld.com/sites/default/files/082010/logo_CCNNNA.png",
             "http://www.brandsoftheworld.com/sites/default/files/082010/RP.png",
             "http://www.brandsoftheworld.com/sites/default/files/082010/Immagine_1.png",
             "http://www.brandsoftheworld.com/sites/default/files/082010/shine.png",
             "http://www.brandsoftheworld.com/sites/default/files/082010/MamosZurnalas_logo.png",
             "http://www.brandsoftheworld.com/sites/default/files/082010/Untitled-1_18.gif",
             "http://www.brandsoftheworld.com/sites/default/files/082010/iron_man_2_2.png",
             "http://www.brandsoftheworld.com/sites/default/files/082010/saojoaodabarra.png",
             "http://www.brandsoftheworld.com/sites/default/files/082010/logo_the_avengers.png",
             "http://www.brandsoftheworld.com/sites/default/files/082010/crystal_shopping.png",
             "http://www.brandsoftheworld.com/sites/default/files/082010/Logo_para_crmall.png"]



    name {Faker::Company.name}
    phone {"2125555" + rand(999).to_s.center(3, rand(9).to_s)}
    image_url {logos[rand(logos.length)]}
    address {Faker::Address.street_address}
    postcodelatlng { PostCode.all.sample }
    zone {["North", "South"][rand(2)]}
    city {["Bengaluru", "Hyderabad", "Gurugram", "Chennai", "Mumbai"][rand(5)]}
    bank_account {rand.to_s[2..9]} 
    sort_code {rand.to_s[2..7]} 
    verified {false}
    num_of_beds {rand(20) + 1}
    nurse_count { rand(num_of_beds/2) }
    carer_break_mins {[30,60][rand(2)]}
    vat_number {rand.to_s[2..9]}
    company_registration_number {rand.to_s[2..7]}
    paid_unpaid_breaks {["Paid", "Unpaid"][rand(2)]}
    parking_available {rand(2)}
    meals_provided_on_shift {rand(2)}
    meals_subsidised {rand(2)}
    po_req_for_invoice {false}
    
    #manual_assignment_flag {false}
  end

  factory :post_code do
    postcode {Array.new(7){[*"A".."Z", *"0".."9"].sample}.join}
    latitude {rand}
    longitude {rand}
  end

  factory :user do

    # hospital_id { hospital.id if hospital }
    title {User::TITLE[rand(User::TITLE.length-1) + 1]}
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password {email.camelize + "1$"}
    phone {"2125555" + rand(999).to_s.center(3, rand(9).to_s)}
    address { Faker::Address.street_address }
    postcodelatlng { PostCode.all.sample }
    #postcodelatlng { PostCode.offset(rand(PostCode.count)).first }
    confirmation_sent_at { Time.now }
    confirmed_at { Time.now }
    sign_in_count { 5 }
    role {"Care Giver"}
    sex { User::SEX[rand(2)]}
    accept_terms {true}
    pref_commute_distance {100000}
    phone_verified {true}

    bank_account {rand.to_s[2..9] if(role != "Admin")}
    sort_code {rand.to_s[2..7] if(role != "Admin")}
    password_reset_date {Date.today}

    trait :new_user do
      confirmed_at nil
      confirmation_sent_at nil
      sign_in_count nil
    end

  end

end
