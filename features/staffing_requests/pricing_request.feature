Feature: Pricing Requests
  Pricing request put in by a care home

Scenario Outline: Pricing Request
  
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>"
  Given the request is on a weekday
  Given the request end time is "<end_time>"
  Given the request start time is "<start_time>"  
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Then the carer amount for the Staffing Request must be "<carer_amount>"
  
  Examples:
  	|care_home		|admin 			|request	                            |start_time |end_time    |rate            |price | carer_amount |
  	|verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:14}   | {carer_weekday:9, care_home_weekday:10}  |{care_home_base:60, care_home_total_amount:72}    | 54 |
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8, min:10}   |{hour:14}   | {carer_weekday:9, care_home_weekday:10}  |{care_home_base:58.33, care_home_total_amount:70}    | 54 |    
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:7}   |{hour:22}   | {carer_weekday:9, carer_weeknight:10, care_home_weekday:10, care_home_weeknight:11}  |{care_home_base:153, care_home_total_amount:183.6}    | 138 |    
  	|verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:18}   |{carer_weekday:9, care_home_weekday:10}  |{care_home_base:100, care_home_total_amount:120}    | 90 |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Generalist     |{hour:7}   |{hour:17}   |{carer_weekday:9, carer_weeknight:10, care_home_weekday:10, care_home_weeknight:12}  |{care_home_base:102, care_home_total_amount:122.4}| 91 |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:20}  |{hour:23}   |{carer_weekday:9, carer_weeknight:10, care_home_weekday:10, care_home_weeknight:15}  |{care_home_base:45, care_home_total_amount:54}    | 30 |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:20, min:10}  |{hour:23}   |{carer_weekday:9, carer_weeknight:10, care_home_weekday:10, care_home_weeknight:15}  |{care_home_base:45, care_home_total_amount:54}    | 30 |    
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:0 }  |{hour:8}    |{carer_weekday:9, carer_weeknight:10, care_home_weekday:10, care_home_weeknight:15}  |{care_home_base:120, care_home_total_amount:144}    | 80 |
    
Scenario Outline: Pricing Request - Custom Rates
  
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>"
  Given the request is on a weekday
  Given the request end time is "<end_time>"
  Given the request start time is "<start_time>"  
  Given the rate is "<rate>"
  Given the custom rate is "<custom_rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Then the carer amount for the Staffing Request must be "<carer_amount>"
  
  Examples:
    |care_home    |admin      |request                              |start_time |end_time    |rate     |custom_rate   |price | carer_amount |
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:14}   | {carer_weekday:8, care_home_weekday:9} | {carer_weekday:9, care_home_weekday:10} |{care_home_base:60, care_home_total_amount:72}    | 54 |
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:18}   | {carer_weekday:8, care_home_weekday:9} | {carer_weekday:9, care_home_weekday:10}  |{care_home_base:100, care_home_total_amount:120}    | 90 |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Generalist     |{hour:7}   |{hour:17}   | {carer_weekday:8, care_home_weekday:9} | {carer_weekday:9, carer_weeknight:10, care_home_weekday:10, care_home_weeknight:12}  |{care_home_base:102, care_home_total_amount:122.4}| 91 |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:20}  |{hour:23}   | {carer_weekday:8, care_home_weekday:9} | {carer_weekday:9, carer_weeknight:10, care_home_weekday:10, care_home_weeknight:15}  |{care_home_base:45, care_home_total_amount:54}    | 30 |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:0 }  |{hour:8}    | {carer_weekday:8, care_home_weekday:9} | {carer_weekday:9, carer_weeknight:10, care_home_weekday:10, care_home_weeknight:15}  |{care_home_base:120, care_home_total_amount:144}    | 80 |
    

Scenario Outline: Pricing Request on Weekend
  
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>"
  Given the request is on a weekend  
  Given the request end time is "<end_time>"
  Given the request start time is "<start_time>"  
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Then the carer amount for the Staffing Request must be "<carer_amount>"
  Examples:
    |care_home    |admin      |request                          |start_time |end_time    |rate|price |carer_amount|
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:14}   |{carer_weekend:10, carer_weekend_night:12, care_home_weekend:13, care_home_weekend_night:15}|{care_home_base:78, care_home_total_amount:93.6} | 60 |
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:18}   |{carer_weekend:10, carer_weekend_night:12, care_home_weekend:13, care_home_weekend_night:15}|{care_home_base:130, care_home_total_amount:156} | 100 |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Generalist     |{hour:7}   |{hour:17}   |{carer_weekend:10, carer_weekend_night:12, care_home_weekend:13, care_home_weekend_night:15}|{care_home_base:132, care_home_total_amount:158.4}|  102 |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:20}  |{hour:23}   |{carer_weekend:10, carer_weekend_night:12, care_home_weekend:13, care_home_weekend_night:15}|{care_home_base:45, care_home_total_amount:54}| 36 |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:0 }  |{hour:8}    |{carer_weekend:10, carer_weekend_night:12, care_home_weekend:13, care_home_weekend_night:15}|{care_home_base:120, care_home_total_amount:144}| 96 |



@wip
Scenario Outline: Pricing Request last minute
  
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>" "<hours>" from now
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Examples:
    |care_home    |admin      |request                              |hours |rate|price   |
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|2     |10  |120     |
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|2.5   |10  |120     |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Generalist     |2.8   |12  |144     |
    |verified=true;carer_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |3     |15  |180     |


Scenario Outline: Pricing Request on bank holiday
  
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>" on a bank holiday
  Given the rate is "<rate>"
  Given there are bank holidays
  Then the price for the Staffing Request must be "<price>"
  Then the carer amount for the Staffing Request must be "<carer_amount>"
  Examples:
    |care_home    |admin      |request                              |rate|price   |carer_amount|
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist |{carer_bank_holiday:15, care_home_bank_holiday:20}|{care_home_base:200, care_home_total_amount:240}| 150 |
    |verified=true;carer_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist |{carer_bank_holiday:15, care_home_bank_holiday:20}|{care_home_base:200, care_home_total_amount:240}| 150 |
    


Scenario Outline: Overtime Mins
  
  Given there is a request "<request>"
  Then the request overtime mins must be "<overtime>"
  
  Examples:
    |request                                                      | overtime  |
    |start_date=2017-06-07 00:00:00;end_date=2017-06-07 08:00:00  |480        |
    |start_date=2017-06-07 05:00:00;end_date=2017-06-07 13:00:00  |180        |
    |start_date=2017-06-07 08:00:00;end_date=2017-06-07 13:00:00  |0          |
    |start_date=2017-06-07 20:00:00;end_date=2017-06-08 09:00:00  |720        |
    |start_date=2017-06-07 19:00:00;end_date=2017-06-08 07:00:00  |660        |
    |start_date=2017-06-07 19:00:00;end_date=2017-06-08 09:00:00  |720        |
    |start_date=2017-06-07 10:00:00;end_date=2017-06-07 22:00:00  |120        |
    |start_date=2017-06-07 21:00:00;end_date=2017-06-07 23:30:00  |150        |
    |start_date=2017-06-07 07:00:00;end_date=2017-06-08 07:00:00  |720        |
    |start_date=2017-06-07 21:00:00;end_date=2017-06-08 21:00:00  |720        |
    |start_date=2017-06-07 7:00:00;end_date=2017-06-07 22:00:00   |180        |
  