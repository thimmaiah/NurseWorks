require 'rails_helper'

RSpec.describe "referrals/index", type: :view do
  before(:each) do
    assign(:referrals, [
      Referral.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :email => "Email",
        :role => "Role",
        :user_id => 2
      ),
      Referral.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :email => "Email",
        :role => "Role",
        :user_id => 2
      )
    ])
  end

  it "renders a list of referrals" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Role".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
