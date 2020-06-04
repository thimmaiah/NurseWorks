Feature: Manual Shift
  Generate a shift for temps given a new request

Scenario Outline: New Shift
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital
  And a manual shift is created
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 
  Given jobs are being dispatched
  Then the user receives an email with "New Shift Available" in the subject

  Examples:
  	|request	                           | user                            |
  	|role=Care Giver                     |role=Care Giver;verified=true    |
  	|role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |role=Nurse;speciality=Generalist    |role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Mental Health |role=Nurse;speciality=Mental Health;verified=true |  