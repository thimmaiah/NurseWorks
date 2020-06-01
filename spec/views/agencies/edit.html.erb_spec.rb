require 'rails_helper'

RSpec.describe "agencies/edit", type: :view do
  before(:each) do
    @agency = assign(:agency, Agency.create!(
      :name => "MyString",
      :address => "MyString",
      :postcode => "MyString",
      :phone => "MyString",
      :broadcast_group => "MyString"
    ))
  end

  it "renders the edit agency form" do
    render

    assert_select "form[action=?][method=?]", agency_path(@agency), "post" do

      assert_select "input#agency_name[name=?]", "agency[name]"

      assert_select "input#agency_address[name=?]", "agency[address]"

      assert_select "input#agency_postcode[name=?]", "agency[postcode]"

      assert_select "input#agency_phone[name=?]", "agency[phone]"

      assert_select "input#agency_broadcast_group[name=?]", "agency[broadcast_group]"
    end
  end
end
