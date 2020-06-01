Feature: Cancel Requests
  Close a request put in by a care home

Scenario Outline: Cancel Request for care_home
  
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there are "<number>" of verified requests
  Given Im logged in
  Given there are "<number>" of shifts for the care_home
  When I click "View Staffing Requests"
  When I click on the request
  When the request is cancelled by the user
  Then the request must be cancelled
  Then I should see the "Cancelled Request"


  Examples:
    |care_home    |admin                    |number | user                            |
    |verified=true|role=Admin;verified=true |1      | role=Care Giver;verified=true   |
    |verified=true|role=Admin;verified=true |1      | role=Nurse;verified=true        |

