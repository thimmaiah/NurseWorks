require 'rails_helper'

RSpec.describe "stats/index", type: :view do
  before(:each) do
    assign(:stats, [
      Stat.create!(
        :name => "Name",
        :description => "Description",
        :value => "Value"
      ),
      Stat.create!(
        :name => "Name",
        :description => "Description",
        :value => "Value"
      )
    ])
  end

  it "renders a list of stats" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
