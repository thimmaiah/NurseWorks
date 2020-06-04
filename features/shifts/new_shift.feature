Feature: New Shift
  Generate a shift for temps given a new request

Scenario Outline: New Shift
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
  	|request	                           | user                            |
  	|role=Care Giver                     |role=Care Giver;verified=true    |
    |role=Nurse                          |role=Nurse;verified=true         |
  	|role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Mental Health |role=Nurse;speciality=Mental Health;verified=true |
  	


Scenario Outline: New Shift for preferred care givers
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given there is a user "<user>"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital  
  Given the hospital has a preferred care giver  
  And the shift creator job runs
  Then A shift must be created for the preferred care giver for the request
  And the request broadcast status must change to "Sent"

  Examples:
    |request                             | user                            |
    |role=Care Giver                     |role=Care Giver;verified=true    |
    |role=Nurse                          |role=Nurse;verified=true         |
    |role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Mental Health |role=Nurse;speciality=Mental Health;verified=true |


Scenario Outline: New Shift for specialist users with no match
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital  
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                              | user                            |
    |role=Nurse;speciality=Generalist     |role=Care Giver;verified=true    |    
    |role=Care Giver;speciality=Generalist|role=Nurse;verified=true         |    
    |role=Nurse;speciality=Generalist     |role=Care Giver;speciality=Mental Health;verified=true  |
    |role=Nurse                           |role=Care Giver;speciality=Pediatric Care;verified=true |
    |role=Care Giver;speciality=Generalist     |role=Care Giver;verified=true;work_weekdays=false;work_weekends=false  |
    |role=Care Giver;speciality=Generalist     |role=Care Giver;verified=true;pause_shifts=true    |


Scenario Outline: New Shift for specialist users with no match for weekend
  
  Given there is a request "<request>"
  Given the request is on a weekend
  Given there is a user "<user>"
  Given the carer is mapped to the hospital  
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                   | user                            |
    |role=Care Giver;speciality=Generalist     |role=Care Giver;verified=true;work_weekends=false  |
    

Scenario Outline: New Shift for specialist users with no match for night hours
  
  Given there is a request "<request>"
  Given the request end time is "{hour: 22}"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital  
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                               | user                            |
    |role=Care Giver;speciality=Generalist |role=Care Giver;verified=true;work_weeknights=false;work_weekend_nights=false  |

    
    
Scenario Outline: New Shift for manual assignment hospitals
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Given the request manual assignment is set to "false"
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
    |request                                      | user                          |
    |role=Nurse;manual_assignment_flag=true       |role=Nurse;verified=true       |    
    |role=Care Giver;manual_assignment_flag=true  |role=Care Giver;verified=true  |    


Scenario Outline: New Shift for unverified users
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital
  Given the user is verified "false"
  And the shift creator job runs
  Then A shift must not be created for the user for the request

  Examples:
    |request                                        | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=false  |
    |start_code=1111;end_code=0000 | role=Nurse;verified=false       |


Scenario Outline: New Shift without care givers
  
  Given there is a request "<request>"
  And the shift creator job runs
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                       | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=false  |
    |start_code=1111;end_code=0000 | role=Nurse;verified=false       |


Scenario Outline: New Shift when already rejected
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital
  And the user has already rejected this request
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                        | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=true   |
    |start_code=1111;end_code=0000 | role=Nurse;verified=true        |

Scenario Outline: New Shift when already auto rejected
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital
  And the user has already auto rejected this request
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                        | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=true   |
    |start_code=1111;end_code=0000 | role=Nurse;verified=true        |

Scenario Outline: New Shift to different user when already rejected
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital
  And the user has already rejected this request
  Given there is a user "<user>"
  Given the carer is mapped to the hospital
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 
  
  Examples:
    |request                                        | user                            |
    |role=Care Giver;start_code=1111;end_code=0000  | role=Care Giver;verified=true   |
    |role=Nurse;start_code=1111;end_code=0000       | role=Nurse;verified=true        |


Scenario Outline: New Shift when already booked in the same time shift
  
  Given there is a hospital "verified=true" with an admin "first_name=Admin;role=Admin"
  Given there is a user "<user>"
  Given the carer is mapped to the hospital
  And the user has already accepted a request "<other_request>"
  And give the request has a start_time "8:00" and end time of "16:00"
  Given there is a request "<request>"
  And give the request has a start_time "8:00" and end time of "16:00"
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject
  
  Examples:
    |request          | user                            | other_request     |
    |role=Care Giver  | role=Care Giver;verified=true   | role=Care Giver   |
    |role=Care Giver  | role=Nurse;verified=true        | role=Care Giver   |
    |role=Care Giver  | role=Care Giver;verified=true   | role=Care Giver   |
  
Scenario Outline: New Shift for Sister Care Home
  
  Given there is a request "<request>" for a sister hospital
  Given there is a user "<user>"
  Given the carer is mapped to the hospital of the request
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
    |request                             | user                            |
    |hospital_id=2;role=Care Giver                     |role=Care Giver;verified=true    |
    |hospital_id=2;role=Nurse                          |role=Nurse;verified=true         |
    |hospital_id=3;role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |hospital_id=3;role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |hospital_id=3;role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |hospital_id=3;role=Nurse;speciality=Mental Health |role=Nurse;speciality=Mental Health;verified=true |
