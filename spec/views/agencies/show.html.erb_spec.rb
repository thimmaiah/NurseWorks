require 'rails_helper'

RSpec.describe "agencies/show", type: :view do
  before(:each) do
    @agency = assign(:agency, Agency.create!(
      :name => "Name",
      :address => "Address",
      :postcode => "Postcode",
      :phone => "Phone",
      :broadcast_group => "Broadcast Group"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Postcode/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Broadcast Group/)
  end
end
