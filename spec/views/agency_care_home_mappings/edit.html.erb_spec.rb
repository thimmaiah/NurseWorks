require 'rails_helper'

RSpec.describe "agency_care_home_mappings/edit", type: :view do
  before(:each) do
    @agency_care_home_mapping = assign(:agency_care_home_mapping, AgencyCareHomeMapping.create!(
      :agency => nil,
      :care_home => nil
    ))
  end

  it "renders the edit agency_care_home_mapping form" do
    render

    assert_select "form[action=?][method=?]", agency_care_home_mapping_path(@agency_care_home_mapping), "post" do

      assert_select "input#agency_care_home_mapping_agency_id[name=?]", "agency_care_home_mapping[agency_id]"

      assert_select "input#agency_care_home_mapping_care_home_id[name=?]", "agency_care_home_mapping[care_home_id]"
    end
  end
end
