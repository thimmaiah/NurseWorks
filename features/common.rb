
Given(/^there is a user "([^"]*)"$/) do |arg1|

  args = Hash[arg1.split(";").map{|kv| kv.split("=")}]
  @user = FactoryGirl.build(:user)
  puts "\n ## #{args}"
  if args["specializations"]
    @user.specializations = args["specializations"].split(",")
    args.tap { |hs| hs.delete("specializations") }
  end
  
  key_values_from_hash(@user, args)
  @user.save!

  puts "\n####User####\n"
  puts @user.to_json

end



Given(/^the user has a profile$/) do
  @profile = FactoryGirl.build(:profile)
  @profile.user = @user
  @profile.role = @user.role
  @profile.known_as = @user.first_name
  @profile.save!
  @profile.user_id = @user.id
  @profile.save
end

Then(/^the email has the profile in the body$/) do
  current_email.body.should include("Profile")
  current_email.body.should include("Known As")
  current_email.body.should include("Role")
end


Given(/^there is an unsaved user "([^"]*)"$/) do |arg1|
  @user = FactoryGirl.build(:user)
  key_values(@user, arg1)
  @user.set_defaults
  @user.set_perm_staff_flag
  puts "\n####Unsaved User####\n"
  puts @user.to_json

end

Given(/^the user has no bank account$/) do
  @user.bank_account = nil
  @user.sort_code = nil
  @user.save
end

Then(/^I should see the "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Given(/^Im a logged in user "([^"]*)"$/) do |arg1|
  steps %Q{
    Given there is a user "#{arg1}"
    And I am at the login page
    When I fill and submit the login page
  }
end


Given(/^Im logged in$/) do
  steps %Q{
    And I am at the login page
    When I fill and submit the login page
  }
end

Given(/^the user is logged in$/) do
  steps %Q{
    And I am at the login page
    When I fill and submit the login page
  }
end


Then(/^he must see the message "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Then(/^I must see the message "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Given("the hospital has sister hospitals {string}") do |sch|
  sch.split("#").each do |sch_agrs|
    hospital = FactoryGirl.build(:hospital)
    hospital.verified = true
    key_values(hospital, sch_agrs)
    hospital.save!
  end
  @hospital.sister_hospitals = Hospital.where("id <> ?", @hospital.id).collect(&:id).join(",")
  @hospital.save!
  puts "\n ## sister_hospitals = #{@hospital.sister_hospitals} ##"
end


Given(/^there is a hospital "([^"]*)" with an admin "([^"]*)"$/) do |hospital_args, admin_args|

  @hospital = FactoryGirl.build(:hospital)
  key_values(@hospital, hospital_args)
  @hospital.save!

  @admin = FactoryGirl.build(:user)
  key_values(@admin, admin_args)
  @admin.hospital_id = @hospital.id
  @admin.save!

  puts "Created hospital #{@hospital.id} and admin #{@admin.id}"

end

Given(/^there is a hospital "([^"]*)" with me as admin "([^"]*)"$/) do |hospital_args, admin_args|
  steps %Q{
    Given there is a hospital "#{hospital_args}" with an admin "#{admin_args}"
  }

  @user = @admin
end


Given("the hospital has a permanent nurse") do
  @perm_nurse = FactoryGirl.build(:user, role: "Nurse", hospital_id: @hospital.id, currently_permanent_staff: true)
  @perm_nurse.save!
end

When(/^I click "([^"]*)"$/) do |arg1|
  click_on(arg1)
end

Given(/^jobs are being dispatched$/) do
  sleep(2)
  Delayed::Worker.new.work_off
end

Given(/^jobs are cleared$/) do
  Delayed::Job.delete_all
end

Then("the requestor receives no email") do
  open_email(@staffing_request.user.email)
  expect(current_email).to equal nil
end

Then("the care giver receives an email with {string} in the subject") do |subject|
  open_email(@shift.user.email)
  expect(current_email.subject).to include subject
end


Then("the requestor receives an email with {string} in the subject") do |subject|
  open_email(@staffing_request.user.email)
  expect(current_email.subject).to include subject
end


Then(/^the user receives an email with "([^"]*)" as the subject$/) do |subject|
  open_email(@user.email)
  expect(current_email.subject).to eq subject
end

Then(/^the user receives an email with "([^"]*)" in the subject$/) do |subject|
  open_email(@user.email)
  expect(current_email.subject).to include subject
end


Then(/^the "([^"]*)" receives an email with "([^"]*)" as the subject$/) do |email, subject|
  open_email(email)
  expect(current_email.subject).to eq subject
end

Then(/^the "([^"]*)" receives an email with "([^"]*)" in the subject$/) do |email, subject|
  open_email(email)
  expect(current_email.subject).to include subject
end


Then(/^the admin user receives an email with "([^"]*)" as the subject$/) do |subject|
  open_email(ENV['ADMIN_EMAIL'])
  expect(current_email.subject).to eq subject
end

Then(/^the admin user receives an email with "([^"]*)" in the subject$/) do |subject|
  open_email(ENV['ADMIN_EMAIL'])
  expect(current_email.subject).to include subject
end

Then(/^the user receives no email$/) do
  open_email(@user.email)
  expect(current_email).to eq nil
end

Given(/^there are no bank holidays$/) do
  Holiday.update_all(bank_holiday:false)
  sleep(1)
end

Given(/^there are bank holidays$/) do
  Holiday.update_all(bank_holiday:true)
  sleep(1)
end

Then(/^I should see the all the home page menus "([^"]*)"$/) do |arg1|
  arg1.split(";").each do |menu|
    click_on(menu)
    sleep(0.5)
    page.find(".back-button").click
  end
end

Then(/^I should not see the home page menus "([^"]*)"$/) do |arg1|

  arg1.split(";").each do |menu|
    puts "checking menu #{menu}"
    expect(page).to_not have_content(menu)
  end
end

Given(/^the hospital has no bank account$/) do
  @hospital.bank_account = nil
  @hospital.sort_code = nil
  @hospital.save!
end


Given(/^the user has already closed this request$/) do
  steps %{
      And the user has already accepted this request
      Given jobs are being dispatched
      Then the user receives an email with "Shift Confirmed" in the subject
      And when the user enters the start and end code
      Given jobs are being dispatched
  }
end


When(/^I click "([^"]*)" in the side panel$/) do |arg1|
  page.find(".bar-button-menutoggle").click
  sleep(1)
  click_on(arg1)
  sleep(1)
end

Given("the user is verified {string}") do |arg|
  @user.verified = (arg == "true")  
  @user.save
end
