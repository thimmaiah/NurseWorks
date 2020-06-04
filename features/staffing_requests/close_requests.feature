Feature: Cancel Requests
  Close a request put in by a hospital

Scenario Outline: Cancel Request for hospital
  
  Given there is a hospital "<hospital>" with me as admin "<admin>"
  Given there are "<number>" of verified requests
  Given Im logged in
  Given there are "<number>" of shifts for the hospital
  When I click "View Staffing Requests"
  When I click on the request
  When the request is cancelled by the user
  Then the request must be cancelled
  Then I should see the "Cancelled Request"


  Examples:
    |hospital    |admin                    |number | user                            |
    |verified=true|role=Admin;verified=true |1      | role=Care Giver;verified=true   |
    |verified=true|role=Admin;verified=true |1      | role=Nurse;verified=true        |

