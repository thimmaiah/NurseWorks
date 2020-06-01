Given(/^I am at the care homes registration page$/) do
  #click_on("Register Care Home")
end

When(/^I fill and submit the care homes registration page with  "([^"]*)"$/) do |arg1|
  @care_home = FactoryGirl.build(:care_home)
  fields = ["name", "address", "postcode", "phone", "image_url", 
            "vat_number", "company_registration_number"]
  fields.each do |k|
    fill_in(k, with: @care_home[k], fill_options: { clear: :backspace })
    sleep(1)
  end

  ionic_select(@care_home.carer_break_mins, "carer_break_mins", true)
  ionic_select(@care_home.paid_unpaid_breaks, "paid_unpaid_breaks", true)

  find("#parking_available").click if @care_home.parking_available
  find("#meals_provided_on_shift").click if @care_home.meals_provided_on_shift
  find("#meals_subsidised").click if @care_home.meals_subsidised
  find("#po_req_for_invoice").click if @care_home.po_req_for_invoice
  
  click_on("Save")
end


Then(/^the care home should be created$/) do
  last = CareHome.last
  last.name.should == @care_home.name
  last.postcode.should == @care_home.postcode
  last.phone.should == @care_home.phone
  last.image_url.should == @care_home.image_url  
  last.vat_number.should == @care_home.vat_number
  last.company_registration_number.should == @care_home.company_registration_number

  last.parking_available.should == @care_home.parking_available
  last.meals_provided_on_shift.should == @care_home.meals_provided_on_shift
  last.meals_subsidised.should == @care_home.meals_subsidised
  last.po_req_for_invoice.should == @care_home.po_req_for_invoice
  
end


When("When I claim the care home") do
  click_on("Claim")
  sleep(1)
  click_on("Yes")
end

Then(/^the care home should be unverified$/) do
  last = CareHome.last
  last.verified.should == false
end

Then(/^I should be associated with the care home$/) do
  @user.reload
  @user.care_home_id.should == CareHome.last.id
end

When(/^I search for the care home "([^"]*)"$/) do |arg1|

  @care_home = FactoryGirl.build(:care_home)
  key_values(@care_home, arg1)
  page.find(".searchbar-input").set(@care_home.name)
  sleep(2)
end

When(/^I click on the search result care home$/) do
  within('.list') do
    first('.item').click
  end
  sleep(1)
end

When(/^When I submit the care homes registration page with "([^"]*)"$/) do |arg1|
  sleep(2)

  fields = ["vat_number", "company_registration_number"]
  fields.each do |k|
    fill_in(k, with: @care_home[k], fill_options: { clear: :backspace })
    sleep(1)
  end

  ionic_select(@care_home.carer_break_mins, "carer_break_mins", true)
  ionic_select(@care_home.paid_unpaid_breaks, "paid_unpaid_breaks", true)

  find("#parking_available").click if @care_home.parking_available
  find("#meals_provided_on_shift").click if @care_home.meals_provided_on_shift
  find("#meals_subsidised").click if @care_home.meals_subsidised
  find("#po_req_for_invoice").click if @care_home.po_req_for_invoice

  click_on("Save")
end
