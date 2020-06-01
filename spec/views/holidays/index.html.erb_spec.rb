require 'rails_helper'

RSpec.describe "holidays/index", type: :view do
  before(:each) do
    assign(:holidays, [
      Holiday.create!(
        :name => "Name",
        :bank_holiday => false
      ),
      Holiday.create!(
        :name => "Name",
        :bank_holiday => false
      )
    ])
  end

  it "renders a list of holidays" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
