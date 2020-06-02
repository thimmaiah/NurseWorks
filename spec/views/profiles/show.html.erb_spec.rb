require 'rails_helper'

RSpec.describe "profiles/show", type: :view do
  before(:each) do
    @profile = assign(:profile, Profile.create!(
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
      :nurse_works_policies => false,
      :form_completed_by => "Form Completed By",
      :position => "Position",
      :known_as => "Known As",
      :role => "Role"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Pin/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Crd Dbs Number/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Form Completed By/)
    expect(rendered).to match(/Position/)
    expect(rendered).to match(/Known As/)
    expect(rendered).to match(/Role/)
  end
end
