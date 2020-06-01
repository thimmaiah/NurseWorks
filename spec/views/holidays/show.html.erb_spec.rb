require 'rails_helper'

RSpec.describe "holidays/show", type: :view do
  before(:each) do
    @holiday = assign(:holiday, Holiday.create!(
      :name => "Name",
      :bank_holiday => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
  end
end
