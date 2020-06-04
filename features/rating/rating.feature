Feature: Rating
  Ensure ratings work properly

Scenario Outline: Care Home Rating
  
  Given there is a hospital "verified=true" with me as admin "role=Admin"
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already closed this request
  Given jobs are being dispatched
  Given Im logged in
  When I click "Past Shifts" in the side panel
  When I click the shift for details
  When I click "Rate Care Home"
  And I rate with "<rating>"
  Then the hospital should be rated "<rating>"

  Examples:
    |request                             | user                            | rating |
    |role=Care Giver                     |role=Care Giver;verified=true    | 2 |
    |role=Nurse;speciality=Generalist    |role=Nurse;verified=true         | 3 |
    |role=Nurse;speciality=Generalist    |role=Nurse;speciality=Pediatric Care;verified=true| 4 |


Scenario Outline: Care Giver Rating
  
  Given there is a hospital "verified=true" with me as admin "role=Admin"
  Given there is a request "<request>"
  Given Im logged in
  Given there is a user "<user>"
  And the user has already closed this request
  Given jobs are being dispatched
  When I click "Past Shifts" in the side panel
  When I click the shift for details
  When I click "Rate Care Giver"
  And I rate with "<rating>"
  Then the user should be rated "<rating>"

  Examples:
    |request                             | user                            | rating |
    |role=Care Giver                     |role=Care Giver;verified=true    | 2 |
    |role=Nurse;speciality=Generalist    |role=Nurse;verified=true         | 3 |
    |role=Nurse;speciality=Generalist    |role=Nurse;verified=true         | 4 |
