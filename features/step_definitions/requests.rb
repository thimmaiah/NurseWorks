
Given("the carer is mapped to the care home") do
  User.temps.each do |user|
    CareHomeCarerMapping.create(care_home_id: @care_home.id, user_id: user.id, enabled:true, preferred:false)
  end
end

Given("the carer is mapped to the care home of the request") do
  User.temps.each do |user|
    CareHomeCarerMapping.create(care_home_id: @staffing_request.care_home_id, user_id: user.id, enabled:true, preferred:false)
  end
end


Given(/^a unsaved request "([^"]*)"$/) do |args|

  puts "\n####creating and unsaved request from args \n#{args}\n"

  if(!@care_home)
    steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
    }
  end

  @staffing_request = FactoryGirl.build(:staffing_request)
  # Ensure its not a last minute request
  @staffing_request.created_at = Time.now - 1.day
  @staffing_request.updated_at = Time.now - 1.day
  @staffing_request.start_date = @staffing_request.start_date.change({hour:3.5})
  @staffing_request.end_date = @staffing_request.end_date.change({hour:13.5})
  key_values(@staffing_request, args)
  
  @staffing_request.care_home = @care_home if @staffing_request.care_home_id == nil
  @staffing_request.user = @care_home.users.admins.first
end



Given(/^there is a request "([^"]*)"$/) do |args|
  if(!@care_home)
    steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
    }
  end
  steps %Q{
    Given a unsaved request "#{args}"
  }

  @staffing_request.save!
  puts "\n#####StaffingRequest####\n"
  puts @staffing_request.to_json
end

Given("there is a request {string} for a sister care home") do |args|
  if(!@care_home)
    steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
      Given the care home has sister care homes "name=Awesome Care Home#name=Wonder Care"
    }
  end
  steps %Q{
    Given a unsaved request "#{args}"
  }

  @staffing_request.save!
  puts "\n#####StaffingRequest####\n"
  puts @staffing_request.to_json

end


Given("the request can be started now") do
  @staffing_request.start_date = Time.now
  @staffing_request.end_date = Time.now + 8.hours
  @staffing_request.save!
end

Given(/^the request is on a weekday$/) do
  while(@staffing_request.start_date.on_weekend?)
    @staffing_request.start_date = @staffing_request.start_date + 1.day
    puts "\n Moving start date by 1 day as its curr on a weekend"
  end

  @staffing_request.end_date = @staffing_request.start_date + 8.hours
  @staffing_request.save!
end

Given(/^the request start time is "([^"]*)"$/) do |arg1|
  @staffing_request.start_date = @staffing_request.start_date.change(eval(arg1))
  @staffing_request.save!
end

Given(/^the request end time is "([^"]*)"$/) do |arg1|
  @staffing_request.end_date = @staffing_request.end_date.change(eval(arg1))
  @staffing_request.save!
end


Given(/^the request is on a weekend$/) do
  @staffing_request.start_date = Date.today.end_of_week + 3.5.hours
  @staffing_request.end_date = @staffing_request.start_date + 10.hours
  @staffing_request.save!

  puts "\n#####StaffingRequest####\n"
  puts @staffing_request.to_json
end

Given(/^there is a request "([^"]*)" on a weekend for "([^"]*)"$/) do |arg1, arg2|
  steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
      Given a unsaved request "#{arg1}"
  }

  # Note we only test daytime hours here - hence start at 8:00 am only
  @staffing_request.start_date = Date.today.end_of_week + 3.5.hours
  @staffing_request.end_date = @staffing_request.start_date + arg2.to_f.hours
  @staffing_request.save!

  puts "\n#####StaffingRequest####\n"
  puts @staffing_request.to_json
end

Given(/^there is a request "([^"]*)" "([^"]*)" from now$/) do |arg1, arg2|
  steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
      Given a unsaved request "#{arg1}"
  }

  @staffing_request.start_date = Time.now + arg2.to_f.hours
  @staffing_request.end_date = @staffing_request.start_date + 10.hours
  @staffing_request.save!

  puts "\n#####StaffingRequest####\n"
  puts @staffing_request.to_json

end

Given(/^there is a request "([^"]*)" on a bank holiday$/) do |arg1|

  steps %Q{
      Given there is a care_home "verified=true" with an admin "first_name=Admin;role=Admin"
      Given a unsaved request "#{arg1}"
  }

  @staffing_request.start_date = Date.today.end_of_week + 3.5.hours
  @staffing_request.end_date = @staffing_request.start_date + 10.hours
  @staffing_request.save!

  Holiday.create(name: "Test Holiday", date: @staffing_request.start_date.to_date, bank_holiday: true)

  puts "\n#####StaffingRequest####\n"
  puts @staffing_request.to_json
end



Given(/^there are "(\d+)" of verified requests$/) do |count|
  (1..count.to_i).each do |i|
    puts "\nCreating request #{i}\n" 
    @staffing_request = FactoryGirl.build(:staffing_request)
    @staffing_request.care_home = @care_home
    @staffing_request.user = @care_home.users.admins.first
    @staffing_request.save!
  end
end

Then(/^I must see all the requests$/) do
  StaffingRequest.all.each do |req|
    expect(page).to have_content(@staffing_request.care_home.name)
    expect(page).to have_content(@staffing_request.request_status)
    expect(page).to have_content(@staffing_request.start_date.in_time_zone("London").strftime("%d/%m/%Y %H:%M") )
    expect(page).to have_content(@staffing_request.end_date.in_time_zone("London").strftime("%d/%m/%Y %H:%M") )
  end
end

When(/^I click on the request$/) do
  @staffing_request = StaffingRequest.first
  item = "#StaffingRequest-#{@staffing_request.id}-item"
  page.find(item).click
end

When(/^I click on the request I must see the request details$/) do
  StaffingRequest.all.each do |req|
    item = "#StaffingRequest-#{req.id}-item"
    page.find(item).click
    @staffing_request = req
    steps %Q{
      Then I must see the request details
    }
    page.find(".back-button").click


  end

end

When(/^I create a new Staffing Request "([^"]*)"$/) do |args|
  @staffing_request = FactoryGirl.build(:staffing_request)
  key_values(@staffing_request, args)
  page.find("#new_staffing_request_btn").click()

  if(@care_home.po_req_for_invoice)
    fill_in("po_for_invoice", with: @staffing_request.po_for_invoice, fill_options: { clear: :backspace })
  end


  if @care_home.qr_code == nil
    fields = ["start_code", "end_code"]
    fields.each do |k|
      fill_in(k, with: @staffing_request[k], fill_options: { clear: :backspace })
      sleep(1)
    end
  end  


  ionic_select(@staffing_request.role, "role", true)
  ionic_select(@staffing_request.care_home.name, "care_home_id", true) if @staffing_request.care_home_id
  #ionic_select(@staffing_request.speciality, "speciality", false)

  click_on("Save")
  sleep(1)
  click_on("Yes")
  sleep(2)
end

Then(/^the request must be saved$/) do

  last = StaffingRequest.last

  if @care_home.qr_code == nil  
    @staffing_request.start_code.should == last.start_code
    @staffing_request.end_code.should == last.end_code
  end
  
  @staffing_request.role.should == last.role
  @staffing_request.po_for_invoice.should == last.po_for_invoice

  last.start_date.hour.should == 8
  last.end_date.hour.should == 16

  last.user_id.should == @user.id
  if(@staffing_request.care_home_id)
    last.care_home_id.should == @staffing_request.care_home_id
  else
    last.care_home_id.should == @user.care_home_id
  end
  last.request_status.should == "Open"
  last.payment_status.should == "Unpaid"
  last.broadcast_status.should == "Pending"

end



Then(/^I must see the request details$/) do
  expect(page).to have_content(@staffing_request.care_home.name)
  expect(page).to have_content(@staffing_request.user.first_name)
  expect(page).to have_content(@staffing_request.user.last_name)
  expect(page).to have_content(@staffing_request.role)
  expect(page).to have_content(@staffing_request.request_status)
  expect(page).to have_content(@staffing_request.payment_status)
  expect(page).to have_content(@staffing_request.start_date.in_time_zone("Europe/London").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@staffing_request.end_date.in_time_zone("Europe/London").strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@staffing_request.start_code)
  expect(page).to have_content(@staffing_request.end_code)
end


Then(/^the price for the Staffing Request must be "([^"]*)"$/) do |price|
  # puts "\n######### Pricing ###########\n"
  # puts @staffing_request.to_json

  ret = Rate.price_estimate(@staffing_request)
  computed_prices = eval(price)
  computed_prices.keys.each do |key|
    ret[key].should == computed_prices[key] 
  end
end

Then(/^the carer amount for the Staffing Request must be "([^"]*)"$/) do |arg1|
  @staffing_request.pricing_audit["carer_base"].should == arg1.to_f
end

Given(/^the custom rate is "([^"]*)"$/) do |arg1|    

    params = eval(arg1)
    params["care_home_id"] = @staffing_request.care_home_id
    params["zone"] = @staffing_request.care_home.zone
    params["role"] = @staffing_request.role
    params["speciality"] = @staffing_request.speciality
    Rate.where("care_home_id is not NULL")
            .update_all(params)
end


Given(/^the rate is "([^"]*)"$/) do |arg1|

  params = eval(arg1)
 
  Rate.where(zone:@staffing_request.care_home.zone,
             role:@staffing_request.role,
             speciality: @staffing_request.speciality).update_all(params)
end


Given(/^the request start_date is "([^"]*)" from now$/) do |arg1|
  @staffing_request.start_date = Time.now + eval(arg1)
  @staffing_request.end_date = Time.now + eval(arg1) + 8.hours
  @staffing_request.save!
end

Then(/^the request overtime mins must be "([^"]*)"$/) do |arg1|
  @staffing_request.night_shift_minutes.should == arg1.to_i
end

Then(/^the request must be cancelled$/) do
  sleep(1)
  @staffing_request.reload
  puts "\n######### StaffingRequest Reloaded ###########\n"
  puts @staffing_request.to_json

  @staffing_request.request_status.should == "Cancelled"
end

When(/^the request is cancelled by the user$/) do
  find(".fab-md").click
  sleep(1)
  click_on "Cancel"
  sleep(1)
  click_on "Yes"
end



Given(/^the request manual assignment is set to "([^"]*)"$/) do |arg1|
  @staffing_request.manual_assignment_flag = (arg1 == "true")
  @staffing_request.save!
end

Given("there is a recurring request {string}") do |args|
  @recurring_request = FactoryGirl.build(:recurring_request)
  key_values(@recurring_request, args)
  @recurring_request.care_home = @care_home
  @recurring_request.user = @user
   @recurring_request.dates = []
  @recurring_request.on.split(",").each do |day|
    @recurring_request.dates << (@recurring_request.start_date + day.to_i.days).in_time_zone("Europe/London").strftime("%d/%m/%Y")
  end

  @recurring_request.save!
  # puts "\n #####RecurringRequest#### \n "
  # puts @recurring_request.to_json
end

When("requests are generated for the first time the count should be {string}") do |count|
  @recurring_request.create_for_dates.should == count.to_i
  @recurring_request.reload
  puts "\n #####RecurringRequest#### \n "
  puts @recurring_request.to_json
end

When("requests are generated again then the count should be {string}") do |count|
  @recurring_request.create_for_dates.should == count.to_i
  @recurring_request.reload
  puts "\n #####RecurringRequest#### \n "
  puts @recurring_request.to_json
end


Then("there should be {string} requests generated") do |count|
  StaffingRequest.all.count.should == count.to_i
  StaffingRequest.all.each do |req|
    req.start_date.hour.should == @recurring_request.start_date.hour
    req.end_date.hour.should == @recurring_request.end_date.hour
    req.role.should == @recurring_request.role
    req.speciality.should == @recurring_request.speciality
    req.user_id == @recurring_request.user_id
    req.care_home_id == @recurring_request.care_home_id
  end
end

