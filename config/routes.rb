Rails.application.routes.draw do




  resources :contacts
  resources :references
  resources :care_home_carer_mappings
  resources :agency_user_mappings
  resources :agency_care_home_mappings
  resources :agencies
  resources :stats
  resources :trainings
  resources :profiles
  resources :referrals
  namespace :admin do

    resources :references
    resources :contacts
    
    resources :agency_user_mappings do
      collection do
        post :create_from_user
      end
    end
    resources :agency_care_home_mappings  do
      collection do
        post :create_from_care_home
      end
    end

    resources :agencies
    resources :care_home_carer_mappings

    resources :users do
      collection do
        get :export
        get :export_form        
        get :profile
        post :perform_password_reset                  
      end
      member do
        get :reset_password
        post :scramble
      end
    end
    resources :profiles
    resources :trainings

    resources :care_homes
    resources :payments
    resources :post_codes
    resources :ratings
    
    resources :recurring_requests do
      member do
        get :create_for_week 
      end
    end

    resources :staffing_requests do
      collection do
        get :manual_shift_search_user
      end
      member do 
        get :find_care_givers
        post :manual_shift
      end
    end
    resources :shifts do
      member do 
        get :resend_start_end_codes
      end
    end  
    resources :user_docs
    resources :rates
    resources :referrals
    resources :holidays
    resources :stats
    get '/payments_export', to: 'payments_export#index'
    get '/payments_export/form', to: 'payments_export#form'
    root to: "users#index"
  end


  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
  resources :ratings
  resources :payments
  resources :user_docs

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    passwords: 'passwords',
    confirmations: 'confirmations'
  }

  resources :hiring_responses
  resources :hiring_requests
  
  resources :care_homes do
    collection do
      get :new_qr_code
      post :claim
    end
  end

  resources :users do
    collection do
      post :send_sms_verification      
      post :verify_sms_verification
      post :resend_confirmation
      get :get_initial_data
      post :reset_password
      post :generate_reset_password_by_sms
      post :reset_password_by_sms      
    end
    member do
      post :delete_requested
    end
  end
  resources :post_codes
  resources :shifts do 
    member do 
      get :reject_anonymously
      get :start_end_shift
    end
  end

  resources :recurring_requests do
    collection do
      post :get_carers
    end
  end
  
  resources :staffing_requests do
    collection do
      post :price
      post :get_carers
    end
  end
  resources :rates
  resources :holidays
  resources :cqc_records do 
    collection do
      get :search_care_homes_and_cqc
    end
  end

  get 'users/unsubscribe/:unsubscribe_hash', to: 'users#unsubscribe', :as => 'unsubscribe'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
