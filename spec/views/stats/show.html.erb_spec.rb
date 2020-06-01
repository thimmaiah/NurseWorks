require 'rails_helper'

RSpec.describe "stats/show", type: :view do
  before(:each) do
    @stat = assign(:stat, Stat.create!(
      :name => "Name",
      :description => "Description",
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Value/)
  end
end
