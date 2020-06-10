Feature: View Shift
  View a shift for temps given a new request

Scenario Outline: View My Shift
  
  Given there is a request "<request>"
  Given there is a user "<user>"
  Given the nurse is mapped to the hospital
  And the shift creator job runs
  Given Im logged in 
  When I click "Pending Shifts"
  Then I must see the shift 
  When I click the shift for details
  Then I must see the shift details

  Examples:
  	|request	                           | user                            |
  	|role=Care Giver                     | role=Care Giver;verified=true   |
  	|role=Nurse;speciality=Mental Health | role=Nurse;speciality=Mental Health;verified=true        |
  	
Scenario Outline: Cannot View Others Shifts
  
  Given there are "<number>" of shifts
  Given Im a logged in user "<user>"
  When I click "Pending Shifts"
  Then I must not see the shifts 

  Examples:
    |number | user                            |
    |1      | role=Care Giver;verified=true   |
    |2      | role=Nurse;verified=true        |


Scenario Outline: View All Shifts for hospital
  
  Given there is a hospital "<hospital>" with me as admin "<admin>"
  Given there are "<number>" of verified requests
  Given Im logged in
  Given there are "<number>" of shifts for the hospital
  When I click "Confirmed Shifts"
  Then I must see all the shifts 
  

  Examples:
    |hospital    |admin                    |number | user                            |
    |verified=true|role=Admin;verified=true |1      | role=Care Giver;verified=true   |
    |verified=true|role=Admin;verified=true |2      | role=Nurse;verified=true        |
