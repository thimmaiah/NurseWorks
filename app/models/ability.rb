class Ability
  include CanCan::Ability

  def initialize(user)
    if(!user)
      @user =  User.guest
    else
      @user = user
    end


    case @user.role
    
      when "Super User"
        can [:admin, :manage], :all                
      when "Admin"
        admin_privilages
      when "Employee"
        employee_privilages
      when "Nurse"
        nurse_privilages  
      else
        guest_privilages
    end
      
  end

  
    def guest_privilages
        can :read, Hospital
        can :read, StaffingRequest
        can :create, User
    end

    def nurse_privilages
        guest_privilages
        can :manage, Shift, :user_id=>@user.id
        can :manage, User, :id=>@user.id
        can :manage, UserDoc, :user_id =>@user.id
        can :read, Payment, :user_id =>@user.id
        can :read, Rating, :rated_entity_id =>@user.id, :rated_entity_type=>"User"
        can :create, Rating, :rated_entity_type=>"Hospital"
        can [:read, :manage], Referral, :user_id =>@user.id
        can [:read, :manage], Contact, :user_id =>@user.id
        can [:read, :manage], Reference, :user_id =>@user.id
    end

    def employee_privilages
        can :read, Hospital
        can :read, UserDoc
        can :read, Rating
        can :read, Holiday
        can :read, Shift, :hospital_id=>@user.hospital_id         
        can [:read, :create], Referral, :user_id =>@user.id
    end

    def admin_privilages
        employee_privilages
        can :manage, Hospital, :id=>@user.hospital_id
        can :read, User, :public_profile=>true
        can :manage, User, :hospital_id=>@user.hospital_id
        can :create, StaffingRequest
        can :manage, StaffingRequest  do |req| 
            # We allow people to manage req for the care home they belong to or for sister care homes
            @user.belongs_to_hospital(req.hospital_id)
        end
        can :manage, RecurringRequest  do |req| 
        can :create, RecurringRequest
            # We allow people to manage req for the care home they belong to or for sister care homes
            @user.belongs_to_hospital(req.hospital_id)
        end
        can :read, Shift do |shift| 
            # We allow people to manage req for the care home they belong to or for sister care homes
            @user.belongs_to_hospital(shift.hospital_id)
        end
        can :manage, Payment, :hospital_id =>@user.hospital_id
        can :manage, Rating, :hospital_id =>@user.hospital_id

    end

end
