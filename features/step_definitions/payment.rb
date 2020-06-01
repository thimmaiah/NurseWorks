Given(/^that the user has completed "([^"]*)" of shifts$/) do |number_of_shifts|
  (1..number_of_shifts.to_i).each do |i|	
	steps %Q{
	  Given there is a care_home "verified=true" with an admin "role=Admin"
	  Given there is a request "role=Care Giver"
	  And the user has already accepted this request
	  And when the user enters the start and end code
  	  Given jobs are being dispatched
	}
  end
end

Given(/^the IncentiveJob is run for the month$/) do
  GenerateIncentivesJob.new.perform
end

Then(/^the incentive payment is generated for the user$/) do
  @payment = @user.payments.where(care_home: nil).last
  @payment.should_not == nil
end

Then(/^the incentive payment is not generated for the user$/) do
  @payment = @user.payments.where(care_home: nil).last
  @payment.should == nil
end


Then(/^the incentive amount is "([^"]*)"$/) do |amount|
  @payment.care_giver_amount.should == amount.to_f
end
