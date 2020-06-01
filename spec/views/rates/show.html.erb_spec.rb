require 'rails_helper'

RSpec.describe "rates/show", type: :view do
  before(:each) do
    @rate = assign(:rate, Rate.create!(
      :zone => "Zone",
      :role => "Role",
      :speciality => "Speciality",
      :amount => 2.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Zone/)
    expect(rendered).to match(/Role/)
    expect(rendered).to match(/Speciality/)
    expect(rendered).to match(/2.5/)
  end
end
