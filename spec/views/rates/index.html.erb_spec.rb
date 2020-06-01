require 'rails_helper'

RSpec.describe "rates/index", type: :view do
  before(:each) do
    assign(:rates, [
      Rate.create!(
        :zone => "Zone",
        :role => "Role",
        :speciality => "Speciality",
        :amount => 2.5
      ),
      Rate.create!(
        :zone => "Zone",
        :role => "Role",
        :speciality => "Speciality",
        :amount => 2.5
      )
    ])
  end

  it "renders a list of rates" do
    render
    assert_select "tr>td", :text => "Zone".to_s, :count => 2
    assert_select "tr>td", :text => "Role".to_s, :count => 2
    assert_select "tr>td", :text => "Speciality".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
  end
end
