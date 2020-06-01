

Given(/^I am at the login page$/) do
  visit("/")
  click_on("Login")
  sleep(1)
end

When(/^I fill and submit the login page$/) do
  fill_in('email', with: @user.email)
  fill_in('password', with: @user.email.camelize + "1$")
  click_on("Login")
  sleep(1)
end

When(/^I fill the password incorrectly and submit the login page$/) do
  fill_in('email', with: @user.email)
  fill_in('password', with: "Wrong pass")
  click_on("Login")
  sleep(1)
end

When("I fill and submit the reset password") do
  fill_in('email', with: @user.email)
  click_on("Forgot Password")
  sleep(1)
end

When("I fill out the password reset page with {string}") do |new_password|
  @user.reload
  fill_in('secret', with: @user.password_reset_code)
  fill_in('password', with: new_password)
  fill_in('confirm_password', with: new_password)
  click_on("Reset Password")
  sleep(1)
end

When("I fill and submit the login page with the password {string}") do |new_password|
  fill_in('email', with: @user.email)
  fill_in('password', with: new_password)
  click_on("Login")
  sleep(1)
end
