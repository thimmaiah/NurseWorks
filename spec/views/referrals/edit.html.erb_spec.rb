require 'rails_helper'

RSpec.describe "referrals/edit", type: :view do
  before(:each) do
    @referral = assign(:referral, Referral.create!(
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :role => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit referral form" do
    render

    assert_select "form[action=?][method=?]", referral_path(@referral), "post" do

      assert_select "input#referral_first_name[name=?]", "referral[first_name]"

      assert_select "input#referral_last_name[name=?]", "referral[last_name]"

      assert_select "input#referral_email[name=?]", "referral[email]"

      assert_select "input#referral_role[name=?]", "referral[role]"

      assert_select "input#referral_user_id[name=?]", "referral[user_id]"
    end
  end
end
