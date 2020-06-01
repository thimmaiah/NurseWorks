require 'rails_helper'

RSpec.describe "agency_user_mappings/show", type: :view do
  before(:each) do
    @agency_user_mapping = assign(:agency_user_mapping, AgencyUserMapping.create!(
      :agency => nil,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
