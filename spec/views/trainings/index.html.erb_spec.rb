require 'rails_helper'

RSpec.describe "trainings/index", type: :view do
  before(:each) do
    assign(:trainings, [
      Training.create!(
        :name => "Name",
        :undertaken => false,
        :profile_id => 2,
        :user_id => 3
      ),
      Training.create!(
        :name => "Name",
        :undertaken => false,
        :profile_id => 2,
        :user_id => 3
      )
    ])
  end

  it "renders a list of trainings" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
