require 'rails_helper'

RSpec.describe "schools/show", type: :view do
  before(:each) do
    @school = assign(:school, School.create!(
      :name => "Name",
      :address => "Address",
      :rank => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/2/)
  end
end
