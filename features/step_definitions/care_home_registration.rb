Given(/^I am at the hospitals registration page$/) do
  #click_on("Register Care Home")
end

When(/^I fill and submit the hospitals registration page with  "([^"]*)"$/) do |arg1|
  @hospital = FactoryGirl.build(:hospital)
  fields = ["name", "address", "postcode", "phone", "image_url", 
            "vat_number", "company_registration_number"]
  fields.each do |k|
    fill_in(k, with: @hospital[k], fill_options: { clear: :backspace })
    sleep(1)
  end

  ionic_select(@hospital.carer_break_mins, "carer_break_mins", true)
  ionic_select(@hospital.paid_unpaid_breaks, "paid_unpaid_breaks", true)

  find("#parking_available").click if @hospital.parking_available
  find("#meals_provided_on_shift").click if @hospital.meals_provided_on_shift
  find("#meals_subsidised").click if @hospital.meals_subsidised
  find("#po_req_for_invoice").click if @hospital.po_req_for_invoice
  
  click_on("Save")
end


Then(/^the hospital should be created$/) do
  last = Hospital.last
  last.name.should == @hospital.name
  last.postcode.should == @hospital.postcode
  last.phone.should == @hospital.phone
  last.image_url.should == @hospital.image_url  
  last.vat_number.should == @hospital.vat_number
  last.company_registration_number.should == @hospital.company_registration_number

  last.parking_available.should == @hospital.parking_available
  last.meals_provided_on_shift.should == @hospital.meals_provided_on_shift
  last.meals_subsidised.should == @hospital.meals_subsidised
  last.po_req_for_invoice.should == @hospital.po_req_for_invoice
  
end


When("When I claim the hospital") do
  click_on("Claim")
  sleep(1)
  click_on("Yes")
end

Then(/^the hospital should be unverified$/) do
  last = Hospital.last
  last.verified.should == false
end

Then(/^I should be associated with the hospital$/) do
  @user.reload
  @user.hospital_id.should == Hospital.last.id
end

When(/^I search for the hospital "([^"]*)"$/) do |arg1|

  @hospital = FactoryGirl.build(:hospital)
  key_values(@hospital, arg1)
  page.find(".searchbar-input").set(@hospital.name)
  sleep(2)
end

When(/^I click on the search result hospital$/) do
  within('.list') do
    first('.item').click
  end
  sleep(1)
end

When(/^When I submit the hospitals registration page with "([^"]*)"$/) do |arg1|
  sleep(2)

  fields = ["vat_number", "company_registration_number"]
  fields.each do |k|
    fill_in(k, with: @hospital[k], fill_options: { clear: :backspace })
    sleep(1)
  end

  ionic_select(@hospital.carer_break_mins, "carer_break_mins", true)
  ionic_select(@hospital.paid_unpaid_breaks, "paid_unpaid_breaks", true)

  find("#parking_available").click if @hospital.parking_available
  find("#meals_provided_on_shift").click if @hospital.meals_provided_on_shift
  find("#meals_subsidised").click if @hospital.meals_subsidised
  find("#po_req_for_invoice").click if @hospital.po_req_for_invoice

  click_on("Save")
end
