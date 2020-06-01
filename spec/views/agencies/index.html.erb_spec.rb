require 'rails_helper'

RSpec.describe "agencies/index", type: :view do
  before(:each) do
    assign(:agencies, [
      Agency.create!(
        :name => "Name",
        :address => "Address",
        :postcode => "Postcode",
        :phone => "Phone",
        :broadcast_group => "Broadcast Group"
      ),
      Agency.create!(
        :name => "Name",
        :address => "Address",
        :postcode => "Postcode",
        :phone => "Phone",
        :broadcast_group => "Broadcast Group"
      )
    ])
  end

  it "renders a list of agencies" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Postcode".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Broadcast Group".to_s, :count => 2
  end
end
