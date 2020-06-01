require 'rails_helper'

RSpec.describe "rates/new", type: :view do
  before(:each) do
    assign(:rate, Rate.new(
      :zone => "MyString",
      :role => "MyString",
      :speciality => "MyString",
      :amount => 1.5
    ))
  end

  it "renders new rate form" do
    render

    assert_select "form[action=?][method=?]", rates_path, "post" do

      assert_select "input#rate_zone[name=?]", "rate[zone]"

      assert_select "input#rate_role[name=?]", "rate[role]"

      assert_select "input#rate_speciality[name=?]", "rate[speciality]"

      assert_select "input#rate_amount[name=?]", "rate[amount]"
    end
  end
end
