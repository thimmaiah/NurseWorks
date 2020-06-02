require 'rails_helper'

RSpec.describe "profiles/edit", type: :view do
  before(:each) do
    @profile = assign(:profile, Profile.create!(
      :user_id => 1,
      :pin => "MyString",
      :enhanced_crb => false,
      :crd_dbs_returned => false,
      :isa_returned => false,
      :crd_dbs_number => "MyString",
      :eligible_to_work_UK => false,
      :confirmation_of_identity => false,
      :dl_passport => false,
      :all_required_paperwork_checked => false,
      :registered_under_disability_act => false,
      :nurse_works_policies => false,
      :form_completed_by => "MyString",
      :position => "MyString",
      :known_as => "MyString",
      :role => "MyString"
    ))
  end

  it "renders the edit profile form" do
    render

    assert_select "form[action=?][method=?]", profile_path(@profile), "post" do

      assert_select "input#profile_user_id[name=?]", "profile[user_id]"

      assert_select "input#profile_pin[name=?]", "profile[pin]"

      assert_select "input#profile_enhanced_crb[name=?]", "profile[enhanced_crb]"

      assert_select "input#profile_crd_dbs_returned[name=?]", "profile[crd_dbs_returned]"

      assert_select "input#profile_isa_returned[name=?]", "profile[isa_returned]"

      assert_select "input#profile_crd_dbs_number[name=?]", "profile[crd_dbs_number]"

      assert_select "input#profile_eligible_to_work_UK[name=?]", "profile[eligible_to_work_UK]"

      assert_select "input#profile_confirmation_of_identity[name=?]", "profile[confirmation_of_identity]"

      assert_select "input#profile_dl_passport[name=?]", "profile[dl_passport]"

      assert_select "input#profile_all_required_paperwork_checked[name=?]", "profile[all_required_paperwork_checked]"

      assert_select "input#profile_registered_under_disability_act[name=?]", "profile[registered_under_disability_act]"

      assert_select "input#profile_nurse_works_policies[name=?]", "profile[nurse_works_policies]"

      assert_select "input#profile_form_completed_by[name=?]", "profile[form_completed_by]"

      assert_select "input#profile_position[name=?]", "profile[position]"

      assert_select "input#profile_known_as[name=?]", "profile[known_as]"

      assert_select "input#profile_role[name=?]", "profile[role]"
    end
  end
end
