Feature: New Shift
  Generate a shift for temps given a new request

Scenario Outline: New Shift
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
  	|request	                                            | user                                                  |
  	|role=Nurse;speciality=OT nurse;staff_type=Temp       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=false      |
    |role=Nurse;speciality=Pediatric Care;staff_type=Temp |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=false|
    |role=Nurse;speciality=Mental Health;staff_type=Temp  |role=Nurse;specializations=Mental Health;verified=true;currently_permanent_staff=false |
  	|role=Nurse;speciality=OT nurse;staff_type=Perm       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=true       |
    |role=Nurse;speciality=Pediatric Care;staff_type=Perm |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=true |
    |role=Nurse;speciality=Mental Health;staff_type=Perm  |role=Nurse;specializations=Mental Health;verified=true;currently_permanent_staff=true  |
  	


Scenario Outline: New Shift for preferred care givers
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given there is a user "<user>"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital  
  Given the request has a preferred nurse  
  And the shift creator job runs
  Then A shift must be created for the preferred nurse for the request
  And the request broadcast status must change to "Sent"

  Examples:
    |request                                              | user                                                                                  |
    |role=Nurse;speciality=OT nurse;staff_type=Temp       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=false      |
    |role=Nurse;speciality=Pediatric Care;staff_type=Temp |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=false|
    |role=Nurse;speciality=Mental Health;staff_type=Temp  |role=Nurse;specializations=Mental Health;verified=true;currently_permanent_staff=false |
  	|role=Nurse;speciality=OT nurse;staff_type=Perm       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=true       |
    |role=Nurse;speciality=Pediatric Care;staff_type=Perm |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=true |
    |role=Nurse;speciality=Mental Health;staff_type=Perm  |role=Nurse;specializations=Mental Health;verified=true;currently_permanent_staff=true  |
  	

Scenario Outline: New Shift for specialist users with no match
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital  
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                              | user                            |
    |role=Nurse;speciality=OT nurse;staff_type=Temp       |role=Nurse;verified=true;specializations=Medical wards/other;currently_permanent_staff=false      |
    |role=Nurse;speciality=Pediatric Care;staff_type=Temp |role=Nurse;specializations=OT nurse;verified=true;currently_permanent_staff=false|
    |role=Nurse;speciality=Mental Health;staff_type=Temp  |role=Nurse;specializations=OT nurse;verified=true;currently_permanent_staff=false |
  	|role=Nurse;speciality=OT nurse;staff_type=Perm       |role=Nurse;verified=true;specializations=Medical wards/other;currently_permanent_staff=true       |
    |role=Nurse;speciality=Pediatric Care;staff_type=Perm |role=Nurse;specializations=OT nurse;verified=true;currently_permanent_staff=true |
    |role=Nurse;speciality=Mental Health;staff_type=Perm  |role=Nurse;specializations=OT nurse;verified=true;currently_permanent_staff=true  |
  	

Scenario Outline: New Shift for specialist users with no match for weekend
  
  Given there is a request "<request>"
  Given the request is on a weekend
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital  
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                          | user                            |
    |role=Nurse;speciality=OT nurse;staff_type=Temp   |role=Nurse;specializations=OT nurse;verified=true;work_weekends=false  |
    

Scenario Outline: New Shift for specialist users with no match for night hours
  
  Given there is a request "<request>"
  Given the request end time is "{hour: 22}"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital  
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                          | user                            |
    |role=Nurse;speciality=OT nurse;staff_type=Temp   |role=Nurse;specializations=OT nurse;verified=true;work_weeknights=false;work_weekend_nights=false  |
    
    
    
Scenario Outline: New Shift for manual assignment hospitals
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Given the request manual assignment is set to "false"
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
    |request                                      | user                          |
    |role=Nurse;speciality=OT nurse;staff_type=Temp;manual_assignment_flag=true       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=false      |
    |role=Nurse;speciality=Pediatric Care;staff_type=Temp;manual_assignment_flag=true |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=false|
    

Scenario Outline: New Shift for unverified users
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital
  Given the user is verified "false"
  And the shift creator job runs
  Then A shift must not be created for the user for the request

  Examples:
    |request                                              | user                            |
    |role=Nurse;speciality=Mental Health;staff_type=Temp  |role=Nurse;specializations=Mental Health;verified=false;currently_permanent_staff=false |
  	|role=Nurse;speciality=OT nurse;staff_type=Perm       |role=Nurse;verified=false;specializations=OT nurse;currently_permanent_staff=true       |


Scenario Outline: New Shift without nurses
  
  Given there is a request "<request>"
  And the shift creator job runs
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                              | user                            |
  	|role=Nurse;speciality=OT nurse;staff_type=Temp       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=false      |
    |role=Nurse;speciality=Pediatric Care;staff_type=Temp |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=false|


Scenario Outline: New Shift when already booked in the same time shift
  
  Given there is a hospital "verified=true" with an admin "first_name=Admin;role=Admin"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital
  And the user has already accepted a request "<other_request>"
  And give the request has a start_time "8:00" and end time of "16:00"
  Given there is a request "<request>"
  And give the request has a start_time "8:00" and end time of "16:00"
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject
  
  Examples:
    |request                                              | user                                                                                  | other_request     |
  	|role=Nurse;speciality=OT nurse;staff_type=Temp       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=false      | role=Nurse;speciality=OT nurse;staff_type=Temp       |
    |role=Nurse;speciality=Pediatric Care;staff_type=Temp |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=false| role=Nurse;speciality=Pediatric Care;staff_type=Temp |
  
Scenario Outline: New Shift for Sister Care Home
  
  Given there is a request "<request>" for a sister hospital
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital of the request
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
    |request                                                            | user                            |
  	|hospital_id=2;role=Nurse;speciality=OT nurse;staff_type=Temp       |role=Nurse;verified=true;specializations=OT nurse;currently_permanent_staff=false      |
    |hospital_id=3;role=Nurse;speciality=Pediatric Care;staff_type=Temp |role=Nurse;specializations=Pediatric Care;verified=true;currently_permanent_staff=false|
