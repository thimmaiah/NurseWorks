require 'rails_helper'

RSpec.describe "recurring_requests/show", type: :view do
  before(:each) do
    @recurring_request = assign(:recurring_request, RecurringRequest.create!(
      :care_home_id => 2,
      :user_id => 3,
      :start_date => "",
      :role => "Role",
      :speciality => "Speciality",
      :on => "On",
      :audit => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Role/)
    expect(rendered).to match(/Speciality/)
    expect(rendered).to match(/On/)
    expect(rendered).to match(/MyText/)
  end
end
