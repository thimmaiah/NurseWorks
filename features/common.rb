
Given(/^there is a user "([^"]*)"$/) do |arg1|
  @user = FactoryGirl.build(:user)
  key_values(@user, arg1)
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

Given("the care home has sister care homes {string}") do |sch|
  sch.split("#").each do |sch_agrs|
    care_home = FactoryGirl.build(:care_home)
    care_home.verified = true
    key_values(care_home, sch_agrs)
    care_home.save!
  end
  @care_home.sister_care_homes = CareHome.where("id <> ?", @care_home.id).collect(&:id).join(",")
  @care_home.save!
  puts "\n ## sister_care_homes = #{@care_home.sister_care_homes} ##"
end


Given(/^there is a care_home "([^"]*)" with an admin "([^"]*)"$/) do |care_home_args, admin_args|

  @care_home = FactoryGirl.build(:care_home)
  key_values(@care_home, care_home_args)
  @care_home.save!

  @admin = FactoryGirl.build(:user)
  key_values(@admin, admin_args)
  @admin.care_home_id = @care_home.id
  @admin.save!

  puts "Created care_home #{@care_home.id} and admin #{@admin.id}"

end

Given(/^there is a care_home "([^"]*)" with me as admin "([^"]*)"$/) do |care_home_args, admin_args|
  steps %Q{
    Given there is a care_home "#{care_home_args}" with an admin "#{admin_args}"
  }

  @user = @admin
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

Given(/^the care home has no bank account$/) do
  @care_home.bank_account = nil
  @care_home.sort_code = nil
  @care_home.save!
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
