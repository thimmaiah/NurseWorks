Feature: Login
  Login should be allowed only if there are valid credentials

Scenario Outline: Login Successfully
  Given there is a user "<user>"
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user							|msg	|
  	|role=Care Giver	|Welcome|
    |role=Nurse       |Welcome|
  	|role=Admin		    |Register as a Hospital|



Scenario Outline: Login Incorrectly
  Given there is a user "<user>"
  And I am at the login page
  When I fill the password incorrectly and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user							|msg	|
  	|role=Care Giver	|Invalid login credentials|
    |role=Nurse       |Invalid login credentials|
  	|role=Admin		    |Invalid login credentials|



Scenario Outline: Home page menus Care Giver
  Given there is a user "<user>"
  And the user has no bank account
  And I am at the login page
  When I fill and submit the login page
  Then I should see the all the home page menus "<menus>"

  Examples:
    |user                                                   |menus                |
    |role=Care Giver;verified=false;phone_verified=false    |Verify Mobile Number;Degree Certificate;Adhaar Card|
    |role=Nurse;verified=false;phone_verified=false         |Verify Mobile Number;Degree Certificate;Adhaar Card|




Scenario Outline: Home page menus Admin
  Given there is a hospital "<hospital>" with me as admin "<user>"
  And the hospital has no bank account
  And I am at the login page
  When I fill and submit the login page
  Then I should see the all the home page menus "<menus>"

  Examples:
    |hospital     |user                               |menus                |
    |verified=false|role=Admin;verified=false;phone_verified=false    |Verify Mobile Number;|
    |verified=false|role=Admin;verified=false;phone_verified=false    |Verify Mobile Number;|




Scenario Outline: Password reset Successfully
  Given there is a user "<user>"
  And I am at the login page
  When I fill and submit the reset password
  Then I should see the "Sms with password reset secret sent. Please check your phone."
  When I fill out the password reset page with "<new_password>"
  Then I should see the "Password reset successfully, please login with the new password."
  When I fill and submit the login page with the password "<new_password>"
  Then I should see the "<msg>"
    

  Examples:
    |user             |msg    | new_password  |
    |role=Care Giver  |Welcome| Connuct123$   |
    |role=Nurse       |Welcome| Connuct1234$  |
