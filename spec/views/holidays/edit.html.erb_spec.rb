require 'rails_helper'

RSpec.describe "holidays/edit", type: :view do
  before(:each) do
    @holiday = assign(:holiday, Holiday.create!(
      :name => "MyString",
      :bank_holiday => false
    ))
  end

  it "renders the edit holiday form" do
    render

    assert_select "form[action=?][method=?]", holiday_path(@holiday), "post" do

      assert_select "input#holiday_name[name=?]", "holiday[name]"

      assert_select "input#holiday_bank_holiday[name=?]", "holiday[bank_holiday]"
    end
  end
end
