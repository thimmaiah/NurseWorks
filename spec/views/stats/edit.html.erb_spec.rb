require 'rails_helper'

RSpec.describe "stats/edit", type: :view do
  before(:each) do
    @stat = assign(:stat, Stat.create!(
      :name => "MyString",
      :description => "MyString",
      :value => "MyString"
    ))
  end

  it "renders the edit stat form" do
    render

    assert_select "form[action=?][method=?]", stat_path(@stat), "post" do

      assert_select "input#stat_name[name=?]", "stat[name]"

      assert_select "input#stat_description[name=?]", "stat[description]"

      assert_select "input#stat_value[name=?]", "stat[value]"
    end
  end
end
