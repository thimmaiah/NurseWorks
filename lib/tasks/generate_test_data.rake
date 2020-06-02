namespace :nurse_works do

  require "faker"
  require 'digest/sha1'
  require 'factory_girl'


  desc "Cleans p DB - DELETES everything -  watch out"
  task :emptyDB => :environment do
    HospitalCarerMapping.delete_all
    User.delete_all
    Profile.delete_all
    Training.delete_all
    Hospital.delete_all
    Delayed::Job.delete_all
    StaffingRequest.delete_all
    Shift.delete_all
    Payment.delete_all
    Rating.delete_all
    Rate.delete_all
    PaperTrail::Version.delete_all
    Stat.delete_all
  end


  desc "generates fake Hospitals for testing"
  task :generateFakeHospitals => :environment do


    begin

      User::SPECIALITY.each do |sp|
      (1..2).each do | i |
          h = FactoryGirl.build(:hospital)
          h.created_at = Date.today - rand(4).weeks - rand(7).days
          h.specializations = [sp]
          h.save

          h.reload
          #puts u.to_xml(:include => :hospital_industry_mappings)
          puts "Hospital #{h.id}"
        end
      end
    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end

  end

  task :generateFakePostCodes => :environment do
    (1..10).each do 
      p = FactoryGirl.build(:post_code)   
      p.save!
    end
  end

  desc "generates fake users for testing"
  task :generateFakeUsers => :environment do

    images = ["http://cdn2.hubspot.net/hub/494551/file-2603676543-jpg/jacksonnursing/images/top-quality-rns.jpg",
              "http://globe-views.com/dcim/dreams/nurse/nurse-06.jpg",
              "http://i01.i.aliimg.com/wsphoto/v0/1897854059_1/Free-Shipping-Dentist-Medical-Workwear-Clothes-Doctor-Medical-Gowns-Medical-font-b-Coat-b-font-Medical.jpg",
              "http://www.pngall.com/wp-content/uploads/2016/06/Nurse-PNG-Picture.png",
              "http://s23.postimg.org/54ctzeumj/nurse_22.png",
              "https://www.colourbox.com/preview/2703293-nurse-or-doctor-stands-confidently-with-arms-crossed-on-a-white-background.jpg",
              "http://www.greysrecruitment.co.uk/wp-content/uploads/2015/02/nurse-1.png",
              "http://howtobecomeanurse.yolasite.com/resources/male-nurse1.jpg"]
    begin

      hospitals = Hospital.all

      i = 1
      ["Care Giver", "Nurse"].each do |role|
        
        # Now generate some consumers
        User::SPECIALITY.each do |sp|
          (1..2).each do |j|
            u = FactoryGirl.build(:user)        
            u.verified = true
            u.email = "user#{i}@gmail.com"
            u.password = "user#{i}@gmail.com"
            u.role = role
            u.specializations = [sp]
            u.image_url = images[rand(images.length)]
            u.created_at = Date.today - rand(4).weeks - rand(7).days
            u.save!
            u.reload

            
            p = FactoryGirl.build(:profile)
            p.user = u
            p.role = u.role
            p.known_as = u.first_name
            p.save
            (1..3).each do |ti|
              t = FactoryGirl.build(:training)
              t.profile = p
              t.user = u
              t.save
            end
            #puts u.to_xml
            puts "#{u.role} #{u.id}"
            i = i + 1
          end
        end
      end

      
      i = 1
      hospitals.each do |c|
        count = 1
        (0..1).each do |j|
          u = FactoryGirl.build(:user)
          u.email = "admin#{i}@gmail.com"
          u.password = "admin#{i}@gmail.com"
          u.role = "Admin"
          u.hospital_id = c.id
          u.created_at = Date.today - rand(4).weeks - rand(7).days
          u.save
          #puts u.to_xml
          puts "Care Home Admin #{u.id}"
          i = i + 1
        end

        (0..3).each do |j|
          HospitalCarerMapping.create(hospital_id: c.id, user_id: User.temps.shuffle.first.id, 
              enabled:true, preferred: rand(0..1))
        end
      end

      u = FactoryGirl.build(:user)
      u.verified = true
      u.email = "thimmaiah@gmail.com"
      u.password = u.email
      u.first_name="Mohith"
      u.last_name="Thimmaiah"
      # Ensure User role is USER_ROLE_ID
      u.role = "Care Giver"
      u.save
      #puts u.to_xml
      puts "#{u.role} #{u.id}"

      u = FactoryGirl.build(:user)
      u.email = "employee@ubernurse.com"
      u.password = u.email
      u.role = "Employee"
      u.hospital = Hospital.first
      u.save
      #puts u.to_xml
      puts "#{u.role} #{u.id}"

      
      u = FactoryGirl.build(:user)
      u.email = "root@ubernurse.com"
      u.password = u.email
      u.role = "Super User"
      u.save
      #puts u.to_xml
      puts "#{u.role} #{u.id}"


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end

  end

  desc "generates fake users for testing"
  task :generateFakeAdmin => :environment do

    begin

      u = FactoryGirl.build(:user, email: "admin@ubernurse.com", password: "admin@ubernurse.com", role: "Super User")
      u.save


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end

  end

  desc "generates fake req for testing"
  task :generateFakeReq => :environment do

    begin

      hospitals = Hospital.all

      hospitals.each do |c|
        count = rand(3) + 1
        (1..count).each do |j|
          u = FactoryGirl.build(:staffing_request)
          u.created_at = Date.today - rand(4).weeks - rand(7).days
          u.hospital = c
          u.carer_break_mins = c.carer_break_mins
          u.request_status = rand(10) > 2 ? "Approved" : "Rejected"
          u.user = c.users[0]
          u.created_at = Date.today - rand(4).weeks - rand(7).days
          u.save
          #puts u.to_xml
          puts "StaffingRequest #{u.id}"
        end
      end

    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end

  end

  desc "generates fake responses for testing"
  task :generateFakeResp => :environment do

    begin

      reqs = StaffingRequest.open
      care_givers = User.temps.sort_by { rand }

      reqs.each do |req|
        count = 1
        (1..count).each do |j|
          u = FactoryGirl.build(:shift)
          u.staffing_request = req
          u.hospital_id = req.hospital_id
          u.carer_break_mins = req.carer_break_mins
          
          u.user = care_givers[rand(care_givers.length)]
          u.save

          u.response_status =  "Accepted" #rand(2) > 0 ? "Accepted" : "Rejected"
          u.accepted = true
          u.save

          req.broadcast_status = "Sent"
          req.save

          if rand(2) > 0
            u.set_codes_test
            u.reload
            ShiftCloseJob.new.perform(u.id)
          end
          #puts u.to_xml
          puts "Shift #{u.id}"
        end
      end

    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end


  desc "generates fake responses for testing"
  task :generateFakePayments => :environment do

    begin

      resps = Shift.accepted

      resps.each do |resp|
        u = FactoryGirl.build(:payment)
        u.shift = resp
        u.staffing_request_id = resp.staffing_request_id
        u.hospital_id = resp.hospital_id
        u.user_id = resp.user_id
        u.paid_by_id = resp.hospital.users.first
        if rand(2) > 0
          u.save # Generate payments only for some accepted responses
        end
        #puts u.to_xml
        puts "Payment #{u.id}"
      end


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end


  desc "generates fake ratings for testing"
  task :generateFakeRatings => :environment do

    begin

      resps = Shift.accepted

      resps.each do |resp|
        u = FactoryGirl.build(:rating)
        u.shift = resp
        u.rated_entity = resp.user
        u.created_by_id = resp.staffing_request.user_id
        u.hospital_id = resp.staffing_request.hospital_id
        u.save # Generate payments only for some accepted responses
        #puts u.to_xml
        puts "Rating #{u.id}"

        u = FactoryGirl.build(:rating)
        u.shift = resp
        u.rated_entity = resp.hospital
        u.created_by_id = resp.user_id
        u.hospital_id = resp.staffing_request.hospital_id
        
        u.save # Generate payments only for some accepted responses
        #puts u.to_xml
        puts "Rating #{u.id}"
      end


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end

  desc "generates fake rates for testing"
  task :generateFakeRates => :environment do

    begin

        ["North", "South"].each do |zone|
          ["Nurse", "Care Giver"].each do |role|
            User::SPECIALITY.each do |sp|
              u = FactoryGirl.build(:rate)
              #u.speciality = spec
              u.role = role
              u.zone = zone
              u.speciality = sp
              u.save 
              #puts u.to_xml
              puts "Rate #{u.id} "
            end
          end
        end


    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
  end

  task :finalize => :environment do
    Delayed::Job.delete_all
    ShiftCreatorJob.add_to_queue
  end

  desc "Generating all Fake Data"
  task :generateFakeAll => [:emptyDB, :generateFakePostCodes, :generateFakeRates, :generateFakeHospitals, :generateFakeUsers,
  :generateFakeAdmin, :generateFakeReq, :generateFakeResp, 
  :generateFakeRatings, :finalize] do
    puts "Generating all Fake Data"
  end

  task :generateLoadTestData => [:emptyDB, :generateFakePostCodes, :generateFakeRates, :generateFakeHospitals, :generateFakeUsers, :finalize] do
    puts "Generating all Fake Data"
  end



end