require 'rails_helper'

RSpec.describe "rates/edit", type: :view do
  before(:each) do
    @rate = assign(:rate, Rate.create!(
      :zone => "MyString",
      :role => "MyString",
      :speciality => "MyString",
      :amount => 1.5
    ))
  end

  it "renders the edit rate form" do
    render

    assert_select "form[action=?][method=?]", rate_path(@rate), "post" do

      assert_select "input#rate_zone[name=?]", "rate[zone]"

      assert_select "input#rate_role[name=?]", "rate[role]"

      assert_select "input#rate_speciality[name=?]", "rate[speciality]"

      assert_select "input#rate_amount[name=?]", "rate[amount]"
    end
  end
end
