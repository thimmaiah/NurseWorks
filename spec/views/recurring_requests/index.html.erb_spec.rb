require 'rails_helper'

RSpec.describe "recurring_requests/index", type: :view do
  before(:each) do
    assign(:recurring_requests, [
      RecurringRequest.create!(
        :care_home_id => 2,
        :user_id => 3,
        :start_date => "",
        :role => "Role",
        :speciality => "Speciality",
        :on => "On",
        :audit => "MyText"
      ),
      RecurringRequest.create!(
        :care_home_id => 2,
        :user_id => 3,
        :start_date => "",
        :role => "Role",
        :speciality => "Speciality",
        :on => "On",
        :audit => "MyText"
      )
    ])
  end

  it "renders a list of recurring_requests" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Role".to_s, :count => 2
    assert_select "tr>td", :text => "Speciality".to_s, :count => 2
    assert_select "tr>td", :text => "On".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
