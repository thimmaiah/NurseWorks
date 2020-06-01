require 'rails_helper'

RSpec.describe "agency_user_mappings/index", type: :view do
  before(:each) do
    assign(:agency_user_mappings, [
      AgencyUserMapping.create!(
        :agency => nil,
        :user => nil
      ),
      AgencyUserMapping.create!(
        :agency => nil,
        :user => nil
      )
    ])
  end

  it "renders a list of agency_user_mappings" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
