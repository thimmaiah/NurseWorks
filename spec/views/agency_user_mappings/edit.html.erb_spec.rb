require 'rails_helper'

RSpec.describe "agency_user_mappings/edit", type: :view do
  before(:each) do
    @agency_user_mapping = assign(:agency_user_mapping, AgencyUserMapping.create!(
      :agency => nil,
      :user => nil
    ))
  end

  it "renders the edit agency_user_mapping form" do
    render

    assert_select "form[action=?][method=?]", agency_user_mapping_path(@agency_user_mapping), "post" do

      assert_select "input#agency_user_mapping_agency_id[name=?]", "agency_user_mapping[agency_id]"

      assert_select "input#agency_user_mapping_user_id[name=?]", "agency_user_mapping[user_id]"
    end
  end
end
