Feature: Confirm Shift
  Accept / Decline shift by a carer

Scenario Outline: Accept My Shift
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the care home
  Given the user has a profile
  And the shift creator job runs
  Given Im logged in 
  When I click "Pending Shifts"
  Then I must see the shift 
  Given jobs are cleared
  When I click the shift for details
  When I click "Accept"
  Then the shift is "Accepted"
  Given jobs are being dispatched
  Then the care giver receives an email with "Shift Confirmed" in the subject
  Then the requestor receives an email with "Shift Confirmed" in the subject  
  And the email has the profile in the body

  Examples:
  	|request	                           | user                            |
  	|role=Care Giver                     | role=Care Giver;verified=true   |
  	|role=Nurse;speciality=Mental Health | role=Nurse;speciality=Mental Health;verified=true        |


Scenario Outline: Decline My Shift
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the care home
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
    |role=Care Giver                     | role=Care Giver;verified=true   |
    |role=Nurse;speciality=Mental Health | role=Nurse;speciality=Mental Health;verified=true        |
