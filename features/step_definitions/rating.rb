When(/^I rate with "([^"]*)"$/) do |arg1|
  sleep(1)
  puts page.find(:xpath, "//*[@id='stars']")
  puts page.find(:xpath, "//*[@id='stars']/ul")
  puts page.find(:xpath, "//*[@id='stars']/ul/li[#{arg1}]")
  page.find(:xpath, "//*[@id='stars']/ul/li[#{arg1}]").click
  sleep(1)
  click_on("Save")
  sleep(1)
end

Then(/^the care home should be rated "([^"]*)"$/) do |arg1|
  @care_home.reload
  @care_home.rating_count.should == 1
  @care_home.total_rating.should == arg1.to_i

  @rating = Rating.last
  @rating.rated_entity_type.should == "CareHome"
  @rating.rated_entity_id.should == @care_home.id
  @rating.stars.should == arg1.to_i
  
end

Then(/^the user should be rated "([^"]*)"$/) do |arg1|
  @user.reload
  @user.rating_count.should == 1
  @user.total_rating.should == arg1.to_i

  @rating = Rating.last
  @rating.rated_entity_type.should == "User"
  @rating.rated_entity_id.should == @user.id
  @rating.stars.should == arg1.to_i
  
end
