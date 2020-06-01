require 'rails_helper'

RSpec.describe "trainings/new", type: :view do
  before(:each) do
    assign(:training, Training.new(
      :name => "MyString",
      :undertaken => false,
      :profile_id => 1,
      :user_id => 1
    ))
  end

  it "renders new training form" do
    render

    assert_select "form[action=?][method=?]", trainings_path, "post" do

      assert_select "input#training_name[name=?]", "training[name]"

      assert_select "input#training_undertaken[name=?]", "training[undertaken]"

      assert_select "input#training_profile_id[name=?]", "training[profile_id]"

      assert_select "input#training_user_id[name=?]", "training[user_id]"
    end
  end
end
