Feature: Confirm Shift
  Accept / Decline shift by a nurse

# Temp staff shifts need to be accepted on the UI and are moved to wait list.
# Then one wait listed shift is picked and accepted. See ShiftResponseJob
Scenario Outline: Accept WAitlisted Shift - Temp
  
  Given there is a request "<request>"
  Given there are "3" nurses "<user>" mapped to the hospital of the request
  And the shift creator job runs
  And all the shifts have a response as Accepted
  Then all the shifts are "Wait Listed"
  And the shift response job runs
  Then the most preferred shift is "Accepted"  
  Given jobs are being dispatched
  Then the selected nurse receives an email with "Shift Confirmed" in the subject
  Then the requestor receives an email with "Shift Confirmed" in the subject  

  Examples:
  	|request	                                            | user                            |
  	|role=Nurse;speciality=OT nurse;staff_type=Temp       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=false      |
    |role=Nurse;speciality=Pediatric Care;staff_type=Temp |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=false|



# Temp staff shifts need to be accepted on the UI and are moved to wait list.
# Then one wait listed shift is picked and accepted. See ShiftResponseJob
Scenario Outline: Accept My Shift - Temp
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital
  Given the user has a profile
  And the shift creator job runs
  Given Im logged in 
  When I click "Pending Shifts"
  Then I must see the shift 
  Given jobs are cleared
  When I click the shift for details
  When I click "Accept"
  Then the shift is "Wait Listed"
  And the shift response job runs
  Then the shift is "Accepted"  
  Given jobs are being dispatched
  Then the care giver receives an email with "Shift Confirmed" in the subject
  Then the requestor receives an email with "Shift Confirmed" in the subject  
  And the email has the profile in the body

  Examples:
  	|request	                                            | user                            |
  	|role=Nurse;speciality=OT nurse;staff_type=Temp       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=false      |
    |role=Nurse;speciality=Pediatric Care;staff_type=Temp |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=false|


# Perm staff shifts are auto accepted 
Scenario Outline: Accept My Shift - Perm
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital
  Given the user has a profile
  And the shift creator job runs
  Then the shift is "Accepted"  
  Given jobs are being dispatched
  Then the care giver receives an email with "Shift Confirmed" in the subject
  Then the requestor receives an email with "Shift Confirmed" in the subject  
  
  Examples:
  	|request	                                            | user                            |
  	|role=Nurse;speciality=OT nurse;staff_type=Perm       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=true       |
    |role=Nurse;speciality=Pediatric Care;staff_type=Perm |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=true |
    

Scenario Outline: Decline My Shift - Temp
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital
  And the shift creator job runs
  Given Im logged in 
  When I click "Pending Shifts"
  Then I must see the shift 
  Given jobs are cleared
  When I click the shift for details
  When I Decline the shift
  Then the shift is "Rejected"
  Given jobs are being dispatched
  Then the care giver receives an email with "Shift Rejected" in the subject
  Then the requestor receives no email

  Examples:
    |request                             | user                            |
    |role=Nurse;speciality=OT nurse;staff_type=Temp       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=false      |
    |role=Nurse;speciality=Pediatric Care;staff_type=Temp |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=false|
    