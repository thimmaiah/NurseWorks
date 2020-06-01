Given(/^I am at the registration page$/) do
  visit("/")
  click_on("Register")
  sleep 1
end

When(/^I fill and submit the registration page$/) do

  role_label = @user.role == "Admin" ? "Partner" : @user.role
  click_on(role_label)
  sleep(1)

  ionic_select(@user.title, "title", true)
  sleep(0.5)  

  fields = [  "first_name", "last_name", "email", "phone", "password"]
  fields.each do |k|
    fill_in(k, with: @user[k])
    sleep(0.5)
  end

  fill_in("password", with: @user.email.camelize + "1$")
  fill_in("confirm_password", with: @user.email.camelize + "1$")

  # select @user.role, :from => "role"
  # select @user.sex, :from => "sex"

  if(@user.role == 'Care Giver' || @user.role == 'Nurse')

    fields = [ "postcode"]
    fields.each do |k|
      fill_in(k, with: @user[k])
      sleep(1)
    end

    ionic_select(@user.pref_commute_distance, "pref_commute_distance", true)
    
    sleep(1)

  end

  find("#accept_terms").click
  click_on("Save")
end

Then(/^when I click the confirmation link$/) do
  @saved_user = User.last
  visit("http://localhost:3000/auth/confirmation?config=default&confirmation_token=#{@saved_user.confirmation_token}&redirect_url=#{ENV['REDIRECT_SUCCESSFULL_EMAIL_VERIFICATION']}")
end

Then(/^the user should be confirmed$/) do
  @saved_user.reload
  @saved_user.confirmed_at.should_not be_nil


  fields = [  "first_name", "last_name", "email", "phone"]
  fields.each do |k|
    expect(@user[k]).to eql(@saved_user[k])
  end


  if(@user.role == 'Care Giver' || @user.role == 'Nurse')
    fields = [ "pref_commute_distance", "postcode"]
    fields.each do |k|
      expect(@user[k]).to eql(@saved_user[k])
    end
  end
end



Given(/^I am at the phone verification page$/) do
  @user.phone_verified.should == false
  sleep(1)
  if @user.role == "Admin"
    page.find(".back-button").click
  end
  click_on("Verify Mobile Number")
end

When(/^I request a sms verification code$/) do
  within("#verification_page") do
    sleep(1)
    click_on("Send Verification Code")
    sleep(2)
  end
  click_on("Yes")
  sleep(1)
end

Then(/^an sms code must be generated$/) do
  @user.reload
  @user.sms_verification_code.should_not == nil
end

Then(/^when I submit the code$/) do
  fill_in("verification_code", with: @user.sms_verification_code)
  sleep(1)
  click_on("Verify Code")
  sleep(1)
end

Then(/^the user should be phone verified$/) do
  @user.reload
  @user.phone_verified.should == true
end
