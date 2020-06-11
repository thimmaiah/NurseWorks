Feature: Auto Reject Shift
  Auto reject a pending shift

Scenario Outline: Auto Reject Shift
  
  Given there is a shift for a user "<user>" with status "Pending"
  And the shift was created "<mins>" before
  And the shift pending job runs
  Then A shift status must be "<status>"

  Examples:
  	|user	                               |mins | status           |
  	|role=Nurse                     | 65  | Auto Rejected    |
  	|role=Nurse;speciality=Generalist    | 62  | Auto Rejected    |
    |role=Nurse                     | 45  | Pending          |
    |role=Nurse;speciality=Generalist    | 28  | Pending          |
    

Scenario Outline: Auto Reject Shift
  
  Given there is a shift for a user "<user>" with status "Pending"
  And the shift was created "<mins>" before
  Given jobs are being dispatched
  And the shift pending job runs
  Then A shift status must be "<status>"
  Given jobs are being dispatched
  Then the care giver receives an email with "Shift Auto Rejected" in the subject
  Then the requestor receives no email
  

  Examples:
    |user                                |mins | status           |
    |role=Nurse                     | 65  | Auto Rejected    |
    |role=Nurse;speciality=Generalist    | 90  | Auto Rejected    |
    