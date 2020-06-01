require 'rails_helper'

RSpec.describe "agency_care_home_mappings/show", type: :view do
  before(:each) do
    @agency_care_home_mapping = assign(:agency_care_home_mapping, AgencyCareHomeMapping.create!(
      :agency => nil,
      :care_home => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
