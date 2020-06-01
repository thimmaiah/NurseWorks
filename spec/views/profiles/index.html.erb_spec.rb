require 'rails_helper'

RSpec.describe "profiles/index", type: :view do
  before(:each) do
    assign(:profiles, [
      Profile.create!(
        :user_id => 2,
        :pin => "Pin",
        :enhanced_crb => false,
        :crd_dbs_returned => false,
        :isa_returned => false,
        :crd_dbs_number => "Crd Dbs Number",
        :eligible_to_work_UK => false,
        :confirmation_of_identity => false,
        :dl_passport => false,
        :all_required_paperwork_checked => false,
        :registered_under_disability_act => false,
        :connuct_policies => false,
        :form_completed_by => "Form Completed By",
        :position => "Position",
        :known_as => "Known As",
        :role => "Role"
      ),
      Profile.create!(
        :user_id => 2,
        :pin => "Pin",
        :enhanced_crb => false,
        :crd_dbs_returned => false,
        :isa_returned => false,
        :crd_dbs_number => "Crd Dbs Number",
        :eligible_to_work_UK => false,
        :confirmation_of_identity => false,
        :dl_passport => false,
        :all_required_paperwork_checked => false,
        :registered_under_disability_act => false,
        :connuct_policies => false,
        :form_completed_by => "Form Completed By",
        :position => "Position",
        :known_as => "Known As",
        :role => "Role"
      )
    ])
  end

  it "renders a list of profiles" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Pin".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Crd Dbs Number".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Form Completed By".to_s, :count => 2
    assert_select "tr>td", :text => "Position".to_s, :count => 2
    assert_select "tr>td", :text => "Known As".to_s, :count => 2
    assert_select "tr>td", :text => "Role".to_s, :count => 2
  end
end
