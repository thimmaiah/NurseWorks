require 'rails_helper'

RSpec.describe "referrals/new", type: :view do
  before(:each) do
    assign(:referral, Referral.new(
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :role => "MyString",
      :user_id => 1
    ))
  end

  it "renders new referral form" do
    render

    assert_select "form[action=?][method=?]", referrals_path, "post" do

      assert_select "input#referral_first_name[name=?]", "referral[first_name]"

      assert_select "input#referral_last_name[name=?]", "referral[last_name]"

      assert_select "input#referral_email[name=?]", "referral[email]"

      assert_select "input#referral_role[name=?]", "referral[role]"

      assert_select "input#referral_user_id[name=?]", "referral[user_id]"
    end
  end
end
