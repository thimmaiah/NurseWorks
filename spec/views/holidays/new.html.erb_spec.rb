require 'rails_helper'

RSpec.describe "holidays/new", type: :view do
  before(:each) do
    assign(:holiday, Holiday.new(
      :name => "MyString",
      :bank_holiday => false
    ))
  end

  it "renders new holiday form" do
    render

    assert_select "form[action=?][method=?]", holidays_path, "post" do

      assert_select "input#holiday_name[name=?]", "holiday[name]"

      assert_select "input#holiday_bank_holiday[name=?]", "holiday[bank_holiday]"
    end
  end
end
