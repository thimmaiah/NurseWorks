Feature: Registration
  Registration should work properly

Scenario Outline: User Registration Successfully
  
  Given there is an unsaved user "<user>"
  And I am at the registration page
  When I fill and submit the registration page
  Then I should see the "<msg1>"
  Then when I click the confirmation link
  Then I should see the "Thank you for taking the time to verify your account and email address"
  Then the user should be confirmed
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg2>"
  Examples:
  	|user						                                                                          |msg1										                      |msg2		  |
  	|role=Nurse;currently_permanent_staff=true;pref_commute_distance=10	                      |Please check your email for verification link	|Welcome	|
  	|role=Nurse;currently_permanent_staff=false;avail_full_time=true;avail_part_time=false   	|Please check your email for verification link	|Welcome	|
    |role=Nurse;currently_permanent_staff=false;avail_full_time=false;avail_part_time=true   	|Please check your email for verification link	|Welcome	|
    |role=Admin                     		                                                      |Please check your email for verification link	|Register as a Hospital	|


Scenario Outline: Register an existing hospital
  
  Given Im a logged in user "<user>"  
  Given there is a hospital "<hospital>" with an admin "role=Admin"
  And I am at the hospitals registration page
  When I search for the hospital "<hospital>"
  And I click on the search result hospital
  And When I claim the hospital
  Then I should see the "<msg1>"
  Given jobs are being dispatched
  Then the admin user receives an email with "Add Admin to Care Home" in the subject
  
  Examples:
    |user        |hospital                             |msg1                                |
    |role=Admin  |name=Kingswood House Nursing Home     |Our support will verify and add you as an admin for this Hospital|
    |role=Admin  |name=Little Haven;nurse_break_mins=30 |Our support will verify and add you as an admin for this Hospital|


Scenario Outline: Register a hospital with cqc
  
  Given Im a logged in user "<user>"  
  And I am at the hospitals registration page
  When I search for the hospital "<hospital>"
  And I click on the search result hospital
  And When I submit the hospitals registration page with "<hospital>"
  Then I should see the "<msg1>"
  And the hospital should be unverified
  And I should be associated with the hospital
  Examples:
    |user        |hospital                             |msg1                                |
    |role=Admin  |name=Kingswood House Nursing Home     |As part of our verification process, we will call your hospital to verify your details|
    |role=Admin  |name=Little Haven;nurse_break_mins=30 |As part of our verification process, we will call your hospital to verify your details|


Scenario Outline: Register a hospital without cqc
  
  Given Im a logged in user "<user>"  
  And I am at the hospitals registration page
  When I search for the hospital "<hospital>"
  And I click "Register New Hospital"
  And I fill and submit the hospitals registration page with  "<hospital>"
  Then I should see the "<msg1>"
  And the hospital should be unverified
  And I should be associated with the hospital
  Examples:
    |user        | hospital                              |msg1                                |
    |role=Admin  |name=Kingswood House Nursing Home       |As part of our verification process, we will call your hospital to verify your details|
    |role=Admin  |name=Little Haven;nurse_break_mins=30   |As part of our verification process, we will call your hospital to verify your details|


Scenario Outline: User Phone Verification
  
  Given Im a logged in user "<user>"  
  And I am at the phone verification page
  When I request a sms verification code
  Then an sms code must be generated
  Then when I submit the code
  Then the user should be phone verified
  Examples:
    |user                                                                    |
    |role=Nurse;verified=false;phone_verified=false   |
    |role=Nurse;verified=false;phone_verified=false        |
    |role=Admin;verified=false;phone_verified=false        |
