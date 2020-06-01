require 'rails_helper'

RSpec.describe "stats/new", type: :view do
  before(:each) do
    assign(:stat, Stat.new(
      :name => "MyString",
      :description => "MyString",
      :value => "MyString"
    ))
  end

  it "renders new stat form" do
    render

    assert_select "form[action=?][method=?]", stats_path, "post" do

      assert_select "input#stat_name[name=?]", "stat[name]"

      assert_select "input#stat_description[name=?]", "stat[description]"

      assert_select "input#stat_value[name=?]", "stat[value]"
    end
  end
end
