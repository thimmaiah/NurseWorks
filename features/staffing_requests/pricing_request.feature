Feature: Pricing Requests
  Pricing request put in by a hospital

Scenario Outline: Pricing Request
  
  Given there is a hospital "<hospital>" with me as admin "<admin>"
  Given there is a request "<request>"
  Given the request is on a weekday
  Given the request end time is "<end_time>"
  Given the request start time is "<start_time>"  
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Then the nurse amount for the Staffing Request must be "<nurse_amount>"
  
  Examples:
  	|hospital		|admin 			|request	                            |start_time |end_time    |rate            |price | nurse_amount |
  	|verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:14}   | {nurse_weekday:9, hospital_weekday:10}  |{hospital_base:60, hospital_total_amount:72}    | 54 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8, min:10}   |{hour:14}   | {nurse_weekday:9, hospital_weekday:10}  |{hospital_base:58.33, hospital_total_amount:70}    | 54 |    
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:7}   |{hour:22}   | {nurse_weekday:9, nurse_weeknight:10, hospital_weekday:10, hospital_weeknight:11}  |{hospital_base:153, hospital_total_amount:183.6}    | 138 |    
  	|verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:18}   |{nurse_weekday:9, hospital_weekday:10}  |{hospital_base:100, hospital_total_amount:120}    | 90 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Generalist     |{hour:7}   |{hour:17}   |{nurse_weekday:9, nurse_weeknight:10, hospital_weekday:10, hospital_weeknight:12}  |{hospital_base:102, hospital_total_amount:122.4}| 91 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:20}  |{hour:23}   |{nurse_weekday:9, nurse_weeknight:10, hospital_weekday:10, hospital_weeknight:15}  |{hospital_base:45, hospital_total_amount:54}    | 30 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:20, min:10}  |{hour:23}   |{nurse_weekday:9, nurse_weeknight:10, hospital_weekday:10, hospital_weeknight:15}  |{hospital_base:45, hospital_total_amount:54}    | 30 |    
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:0 }  |{hour:8}    |{nurse_weekday:9, nurse_weeknight:10, hospital_weekday:10, hospital_weeknight:15}  |{hospital_base:120, hospital_total_amount:144}    | 80 |
    
Scenario Outline: Pricing Request - Custom Rates
  
  Given there is a hospital "<hospital>" with me as admin "<admin>"
  Given there is a request "<request>"
  Given the request is on a weekday
  Given the request end time is "<end_time>"
  Given the request start time is "<start_time>"  
  Given the rate is "<rate>"
  Given the custom rate is "<custom_rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Then the nurse amount for the Staffing Request must be "<nurse_amount>"
  
  Examples:
    |hospital    |admin      |request                              |start_time |end_time    |rate     |custom_rate   |price | nurse_amount |
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:14}   | {nurse_weekday:8, hospital_weekday:9} | {nurse_weekday:9, hospital_weekday:10} |{hospital_base:60, hospital_total_amount:72}    | 54 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:18}   | {nurse_weekday:8, hospital_weekday:9} | {nurse_weekday:9, hospital_weekday:10}  |{hospital_base:100, hospital_total_amount:120}    | 90 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Generalist     |{hour:7}   |{hour:17}   | {nurse_weekday:8, hospital_weekday:9} | {nurse_weekday:9, nurse_weeknight:10, hospital_weekday:10, hospital_weeknight:12}  |{hospital_base:102, hospital_total_amount:122.4}| 91 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:20}  |{hour:23}   | {nurse_weekday:8, hospital_weekday:9} | {nurse_weekday:9, nurse_weeknight:10, hospital_weekday:10, hospital_weeknight:15}  |{hospital_base:45, hospital_total_amount:54}    | 30 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:0 }  |{hour:8}    | {nurse_weekday:8, hospital_weekday:9} | {nurse_weekday:9, nurse_weeknight:10, hospital_weekday:10, hospital_weeknight:15}  |{hospital_base:120, hospital_total_amount:144}    | 80 |
    

Scenario Outline: Pricing Request on Weekend
  
  Given there is a hospital "<hospital>" with me as admin "<admin>"
  Given there is a request "<request>"
  Given the request is on a weekend  
  Given the request end time is "<end_time>"
  Given the request start time is "<start_time>"  
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Then the nurse amount for the Staffing Request must be "<nurse_amount>"
  Examples:
    |hospital    |admin      |request                          |start_time |end_time    |rate|price |nurse_amount|
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:14}   |{nurse_weekend:10, nurse_weekend_night:12, hospital_weekend:13, hospital_weekend_night:15}|{hospital_base:78, hospital_total_amount:93.6} | 60 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:18}   |{nurse_weekend:10, nurse_weekend_night:12, hospital_weekend:13, hospital_weekend_night:15}|{hospital_base:130, hospital_total_amount:156} | 100 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Generalist     |{hour:7}   |{hour:17}   |{nurse_weekend:10, nurse_weekend_night:12, hospital_weekend:13, hospital_weekend_night:15}|{hospital_base:132, hospital_total_amount:158.4}|  102 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:20}  |{hour:23}   |{nurse_weekend:10, nurse_weekend_night:12, hospital_weekend:13, hospital_weekend_night:15}|{hospital_base:45, hospital_total_amount:54}| 36 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |{hour:0 }  |{hour:8}    |{nurse_weekend:10, nurse_weekend_night:12, hospital_weekend:13, hospital_weekend_night:15}|{hospital_base:120, hospital_total_amount:144}| 96 |



@wip
Scenario Outline: Pricing Request last minute
  
  Given there is a hospital "<hospital>" with me as admin "<admin>"
  Given there is a request "<request>" "<hours>" from now
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Examples:
    |hospital    |admin      |request                              |hours |rate|price   |
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|2     |10  |120     |
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist|2.5   |10  |120     |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Generalist     |2.8   |12  |144     |
    |verified=true;nurse_break_mins=0|role=Admin |role=Nurse;speciality=Mental Health  |3     |15  |180     |


Scenario Outline: Pricing Request on bank holiday
  
  Given there is a hospital "<hospital>" with me as admin "<admin>"
  Given there is a request "<request>" on a bank holiday
  Given the rate is "<rate>"
  Given there are bank holidays
  Then the price for the Staffing Request must be "<price>"
  Then the nurse amount for the Staffing Request must be "<nurse_amount>"
  Examples:
    |hospital    |admin      |request                              |rate|price   |nurse_amount|
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist |{nurse_bank_holiday:15, hospital_bank_holiday:20}|{hospital_base:200, hospital_total_amount:240}| 150 |
    |verified=true;nurse_break_mins=0|role=Admin |role=Care Giver;speciality=Generalist |{nurse_bank_holiday:15, hospital_bank_holiday:20}|{hospital_base:200, hospital_total_amount:240}| 150 |
    


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
  