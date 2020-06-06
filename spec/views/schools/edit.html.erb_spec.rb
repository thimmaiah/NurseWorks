require 'rails_helper'

RSpec.describe "schools/edit", type: :view do
  before(:each) do
    @school = assign(:school, School.create!(
      :name => "MyString",
      :address => "MyString",
      :rank => 1
    ))
  end

  it "renders the edit school form" do
    render

    assert_select "form[action=?][method=?]", school_path(@school), "post" do

      assert_select "input[name=?]", "school[name]"

      assert_select "input[name=?]", "school[address]"

      assert_select "input[name=?]", "school[rank]"
    end
  end
end
