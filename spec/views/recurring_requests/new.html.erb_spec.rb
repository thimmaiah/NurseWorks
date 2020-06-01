require 'rails_helper'

RSpec.describe "recurring_requests/new", type: :view do
  before(:each) do
    assign(:recurring_request, RecurringRequest.new(
      :care_home_id => 1,
      :user_id => 1,
      :start_date => "",
      :role => "MyString",
      :speciality => "MyString",
      :on => "MyString",
      :audit => "MyText"
    ))
  end

  it "renders new recurring_request form" do
    render

    assert_select "form[action=?][method=?]", recurring_requests_path, "post" do

      assert_select "input#recurring_request_care_home_id[name=?]", "recurring_request[care_home_id]"

      assert_select "input#recurring_request_user_id[name=?]", "recurring_request[user_id]"

      assert_select "input#recurring_request_start_date[name=?]", "recurring_request[start_date]"

      assert_select "input#recurring_request_role[name=?]", "recurring_request[role]"

      assert_select "input#recurring_request_speciality[name=?]", "recurring_request[speciality]"

      assert_select "input#recurring_request_on[name=?]", "recurring_request[on]"

      assert_select "textarea#recurring_request_audit[name=?]", "recurring_request[audit]"
    end
  end
end
