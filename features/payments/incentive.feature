Feature: Incentive for Nurses
  Ensure Nurses get the incentive they deserve


@wip
Scenario Outline: Compute incentive
 Given there is a user "<user>"
 Given that the user has completed "<number>" of shifts 
 Given the IncentiveJob is run for the month
 Then the incentive payment is generated for the user
 And the incentive amount is "<incentive_amount>"

Examples:
  	| user                            | number 	| incentive_amount 	|
  	| role=Nurse;verified=true   |	3		| 7.5				|
  	| role=Nurse;verified=true   |	5		| 25				|
  	| role=Nurse;verified=true   |	8		| 80				|
	| role=Nurse;verified=true   	  |	3		| 45				|
  	| role=Nurse;verified=true   	  |	5		| 125				|
  	| role=Nurse;verified=true   	  |	8		| 400				|
  
@wip
Scenario Outline: Compute no incentive
 Given there is a user "<user>"
 Given that the user has completed "<number>" of shifts 
 Given the IncentiveJob is run for the month
 Then the incentive payment is not generated for the user
 
Examples:
  	| user                            | number 	|
  	| role=Nurse;verified=true   |	1		|
  	| role=Nurse;verified=true   |	2		|
 	| role=Nurse;verified=true   |	1		|
  	| role=Nurse;verified=true   |	2		|
 