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
  	|user						  |msg1											                      |msg2		  |
  	|role=Care Giver;pref_commute_distance=10	 |Please check your email for verification link	|Welcome	|
    |role=Nurse;pref_commute_distance=15       |Please check your email for verification link  |Welcome  |
    |role=Admin		                             |Please check your email for verification link	|Register as a Partner	|


Scenario Outline: Register an existing care home
  
  Given Im a logged in user "<user>"  
  Given there is a care_home "<care_home>" with an admin "role=Admin"
  And I am at the care homes registration page
  When I search for the care home "<care_home>"
  And I click on the search result care home
  And When I claim the care home
  Then I should see the "<msg1>"
  Given jobs are being dispatched
  Then the admin user receives an email with "Add Admin to Care Home" in the subject
  
  Examples:
    |user        |care_home                             |msg1                                |
    |role=Admin  |name=Kingswood House Nursing Home     |Our support will verify and add you as an admin for this Partner|
    |role=Admin  |name=Little Haven;carer_break_mins=30 |Our support will verify and add you as an admin for this Partner|


Scenario Outline: Register a care home with cqc
  
  Given Im a logged in user "<user>"  
  And I am at the care homes registration page
  When I search for the care home "<care_home>"
  And I click on the search result care home
  And When I submit the care homes registration page with "<care_home>"
  Then I should see the "<msg1>"
  And the care home should be unverified
  And I should be associated with the care home
  Examples:
    |user        |care_home                             |msg1                                |
    |role=Admin  |name=Kingswood House Nursing Home     |As part of our verification process, we will call your care home to verify your details|
    |role=Admin  |name=Little Haven;carer_break_mins=30 |As part of our verification process, we will call your care home to verify your details|


Scenario Outline: Register a care home without cqc
  
  Given Im a logged in user "<user>"  
  And I am at the care homes registration page
  When I search for the care home "<care_home>"
  And I click "Register New Partner"
  And I fill and submit the care homes registration page with  "<care_home>"
  Then I should see the "<msg1>"
  And the care home should be unverified
  And I should be associated with the care home
  Examples:
    |user        | care_home                              |msg1                                |
    |role=Admin  |name=Kingswood House Nursing Home       |As part of our verification process, we will call your care home to verify your details|
    |role=Admin  |name=Little Haven;carer_break_mins=30   |As part of our verification process, we will call your care home to verify your details|


Scenario Outline: User Phone Verification
  
  Given Im a logged in user "<user>"  
  And I am at the phone verification page
  When I request a sms verification code
  Then an sms code must be generated
  Then when I submit the code
  Then the user should be phone verified
  Examples:
    |user                                                                    |
    |role=Care Giver;verified=false;phone_verified=false   |
    |role=Nurse;verified=false;phone_verified=false        |
    |role=Admin;verified=false;phone_verified=false        |
