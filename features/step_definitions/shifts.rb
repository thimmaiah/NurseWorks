

Given(/^the shift creator job runs$/) do
  ShiftCreatorJob.new.perform
  @shift = Shift.last
  puts "\n#{@shift.to_json}\n"
end

Given("the hospital has a preferred care giver") do
  HospitalCarerMapping.where(user_id: @user.id).update_all(preferred: true)
end

Then("A shift must be created for the preferred care giver for the request") do
  @shift.user_id.should == @user.id
end


Then(/^A shift must be created for the user for the request$/) do
  @shift = Shift.last
  @shift.user_id.should == @user.id
  @shift.staffing_request_id.should == @staffing_request.id
  @shift.hospital_id.should == @staffing_request.hospital_id
end

Given(/^the user has already accepted this request$/) do
  puts "\n #{@user.email} accepting request #{@staffing_request.id}"
  @shift = FactoryGirl.build(:shift)
  @shift.user = @user
  @shift.staffing_request = @staffing_request
  @shift.hospital_id = @staffing_request.hospital_id
  @shift.save

  @shift.response_status = "Accepted"
  @shift.save!

  puts "\n#####Accepted Shift####\n"
  puts @shift.to_json
end


Given(/^the user has already rejected this request$/) do
  @shift = FactoryGirl.build(:shift)
  @shift.user = @user
  @shift.staffing_request = @staffing_request
  @shift.hospital_id = @staffing_request.hospital_id
  @shift.save

  @shift.response_status = "Rejected"
  @shift.save!

  puts "\n#####Rejected Shift####\n"
  puts @shift.to_json
end

Given(/^the user has already auto rejected this request$/) do
  @shift = FactoryGirl.build(:shift)
  @shift.user = @user
  @shift.staffing_request = @staffing_request
  @shift.hospital_id = @staffing_request.hospital_id
  @shift.save

  @shift.response_status = "Auto Rejected"
  @shift.save!

  puts "\n#####Rejected Shift####\n"
  puts @shift.to_json
end


Given("the user has already started this request") do
  Shift.where(id: @shift.id).update_all(start_code: @shift.staffing_request.start_code)
end


Then(/^A shift must not be created for the user for the request$/) do
  @user.shifts.not_rejected.where(staffing_request_id:@staffing_request.id).length.should == 0
end


Given(/^the user has already accepted a request "([^"]*)"$/) do |arg1|
  steps %Q{
    Given there is a request "#{arg1}"
    And the user has already accepted this request
  }
end


Then(/^the request broadcast status must change to "([^"]*)"$/) do |arg1|
  @staffing_request.reload
  @staffing_request.broadcast_status.should == arg1
end

Then(/^the users auto selected date should be set to today$/) do
  @user.reload
  (@user.auto_selected_date - Time.now).should  < 100
end

Then(/^I must see the shift$/) do
  @shift = Shift.last
  expect(page).to have_content(@shift.hospital.name)
  if(@user.role  == "Admin")
    expect(page).to have_content(@shift.user.first_name)
    expect(page).to have_content(@shift.user.last_name)
    expect(page).to have_content(@shift.user.phone)
  end
  expect(page).to have_content(@shift.staffing_request.start_date.strftime("%d/%m/%Y %H:%M") )
  expect(page).to have_content(@shift.staffing_request.end_date.strftime("%d/%m/%Y %H:%M") )

end

When(/^I click the shift for details$/) do
  page.find("#shift-#{@shift.id}-item").click
  puts "\n########### Shift Details ############\n"
  puts "\n#{Shift.last.to_json}\n"
end


Then(/^I must see the shift details$/) do

  steps %Q{
    Then I must see the shift 
  }
  @shift.reload
  puts "\n#{@shift.to_json}\n"
  expect(page).to have_content(@shift.response_status)
  expect(page).to have_content(@shift.payment_status)
  expect(page).to have_content(@shift.start_code) if @shift.start_code
  expect(page).to have_content(@shift.end_code) if @shift.end_code

  page.find(".back-button").click
end


Given(/^there are "([^"]*)" of shifts$/) do |count|
  (1..count.to_i).each do |i|
    steps %Q{
      Given there is a user "role=Care Giver;verified=true"
      Given the user has already accepted a request "role=Care Giver"
    } 
  end
end

Given(/^there are "([^"]*)" of shifts for the hospital$/) do |arg1|
  puts "\n StaffingRequest.count = #{StaffingRequest.count} \n"
  StaffingRequest.all.each do |req|
    @staffing_request = req
    puts @staffing_request.to_json

    steps %Q{
      Given there is a user "role=Care Giver;verified=true"
      Given the user has already accepted this request
    }

  end
end


Then(/^I must not see the shifts$/) do
  Shift.all.each do |shift|
    expect(page).to have_content("No Shifts Available")
  end
end


Then(/^I must see all the shifts$/) do
  Shift.all.each do |shift|
    steps %Q{
      Then I must see the shift 
      When I click the shift for details
      Then I must see the shift details
    }
  end
end

Given(/^there is a shift for a user "([^"]*)" with status "([^"]*)"$/) do |arg1, status|
  steps %Q{
    Given there is a request "#{arg1}"
    Given there is a user "#{arg1}"
  }

  @shift = Shift.new(staffing_request_id: @staffing_request.id,
                     hospital_id: @staffing_request.hospital_id,
                     user_id: @user.id,
                     response_status: "Pending")

  @shift.save

  @shift.response_status = status
  @shift.save!
end



Given(/^the shift was created "([^"]*)" before$/) do |arg1|
  @shift.created_at = Time.now - arg1.to_i.minutes
  @shift.save!
end

Given(/^the shift pending job runs$/) do
  clear_emails
  ShiftPendingJob.new.perform()
end

Given(/^the shift confirm job runs$/) do
  clear_emails
  ShiftConfirmJob.new.perform()
end


Then(/^A shift status must be "([^"]*)"$/) do |arg1|
  @shift.reload
  @shift.response_status.should == arg1
end

Given(/^the shift has confirm_sent "([^"]*)" times$/) do |arg1|
  (1..arg1.to_i).each do
    @shift.confirmation_sent
  end
end

Then("the shift confirm_sent count is incremented from {string} by {int}") do |count, inc|
  @shift.reload
  @shift.confirm_sent_count.should == count.to_i + inc
end


Then(/^when the user enters the start and end code$/) do

  # The start date must be now, else the UI will not allow the start code to be entered
  @shift.set_codes_test
end

Then(/^the shift price is computed and stored$/) do
  @shift.reload
  @shift.hospital_base.should_not be nil
end

Then(/^the payment for the shift is generated$/) do
  @payment = Payment.last
  @payment.shift_id.should == @shift.id
  @payment.amount.should == @shift.hospital_total_amount
  @payment.hospital_id.should == @staffing_request.hospital_id
  @payment.user_id.should == @shift.user_id
end

Then(/^the shift is marked as closed$/) do
  @shift.response_status.should == "Closed"
end

Then(/^the request is marked as closed$/) do
  @staffing_request.reload
  @staffing_request.request_status.should == "Closed"
end

Given(/^the shift has a valid start code$/) do
  # The start date must be now, else the UI will not allow the start code to be entered
  @staffing_request.start_date = Time.now
  @staffing_request.end_date = Time.now + 8.hours
  @staffing_request.save!

  @shift.start_code = @shift.staffing_request.start_code
  @shift.save!
end


Given(/^when the user enters the "([^"]*)" "([^"]*)" in the UI$/) do |start_end_field, code|
  steps %Q{
    When I click "Confirmed Shifts"
    Then I must see the shift 
    When I click the shift for details
  }

  # The start date must be now, else the UI will not allow the start code to be entered
  @staffing_request.start_date = Time.now
  @staffing_request.end_date = Time.now + 8.hours
  @staffing_request.save!


  sleep(1)
  start_end_field == 'start_code' ?  click_on("Start Shift") : click_on("End Shift")
  sleep(1)
  fill_in(start_end_field, with: code)
  sleep(1)
  click_on("Submit")
  sleep(1)
  click_on("Yes")
end

Given(/^give the request has a start_time "([^"]*)" and end time of "([^"]*)"$/) do |arg1, arg2|
  start_time = arg1.split(":")
  @staffing_request.start_date = @staffing_request.start_date.change({hour:start_time[0].to_i, minutes:start_time[1].to_i})
  end_time = arg2.split(":")
  @staffing_request.end_date = @staffing_request.end_date.change({hour:end_time[0].to_i, minutes:end_time[1].to_i})
end

Then(/^the shift is "([^"]*)"$/) do |arg1|
  @shift.reload
  @shift.response_status == arg1
end


Given(/^I cancel the shift$/) do
  steps %Q{
    When I click "Confirmed Shifts"
    When I click the shift for details
  }

  click_on "Cancel Shift"
  sleep(1)
  find(".alert-radio-button", :text => "Other").click
  find(".button-inner", :text => "Other").click
  click_on("OK")
  sleep(1)
  click_on "Cancel Shift"
  sleep(1)
end

When("I Decline the shift") do
  click_on "Decline"
  sleep(1)
  find(".alert-radio-button", :text => "Other").click
  find(".button-inner", :text => "Other").click
  click_on("OK")
  sleep(1)
  click_on "Reject Shift"
  sleep(1)
end


Then(/^the shift must be cancelled$/) do
  @shift.reload
  @shift.response_status.should == "Cancelled"
  @shift.staffing_request.broadcast_status.should == "Pending"
  @shift.staffing_request.shift_status.should == nil
end


Given(/^a manual shift is created$/) do
  @shift = Shift.create_shift(@user, @staffing_request)
end


Then(/^the markup should be computed$/) do
  @shift.reload
  puts "hospital_base = #{@shift.hospital_base}, carer_base = #{@shift.carer_base}}"
  @shift.markup.should == (@shift.pricing_audit["hospital_base"] - @shift.pricing_audit["carer_base"]).round(2)
end

Then(/^the total price should be computed$/) do
  hospital_base = @shift.pricing_audit["hospital_base"]
  vat = hospital_base * ENV["VAT"].to_f.round(2)     
  markup = (@shift.pricing_audit["hospital_base"] - @shift.pricing_audit["carer_base"]).round(2)
  @shift.hospital_total_amount.should == (hospital_base + vat).round(2)
end



Given("the user scans the QR code") do
  accepted = @shift.accept_qr_code(@shift.hospital.qr_code, @shift.user)
  accepted.should == true
end

Then("the shift is started") do
  @shift.reload
  @shift.start_code.should == @shift.staffing_request.start_code
  @shift.start_date.should_not == nil
end

Then("the shift is ended") do
  @shift.reload
  @shift.end_code.should == @shift.staffing_request.end_code
  @shift.end_date.should_not == nil
end


Given("the user scans the wrong QR code") do
  accepted = @shift.accept_qr_code(@shift.hospital.qr_code + "000", @shift.user)
  accepted.should == false
end

Then("the shift is not started") do
  @shift.reload
  @shift.start_code.should == nil
  @shift.start_date.should == nil
end
