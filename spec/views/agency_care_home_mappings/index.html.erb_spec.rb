require 'rails_helper'

RSpec.describe "agency_care_home_mappings/index", type: :view do
  before(:each) do
    assign(:agency_care_home_mappings, [
      AgencyCareHomeMapping.create!(
        :agency => nil,
        :care_home => nil
      ),
      AgencyCareHomeMapping.create!(
        :agency => nil,
        :care_home => nil
      )
    ])
  end

  it "renders a list of agency_care_home_mappings" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
