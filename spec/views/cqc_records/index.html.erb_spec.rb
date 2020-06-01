require 'rails_helper'

RSpec.describe "cqc_records/index", type: :view do
  before(:each) do
    assign(:cqc_records, [
      CqcRecord.create!(
        :name => "Name",
        :aka => "Aka",
        :address => "Address",
        :postcode => "Postcode",
        :phone => "Phone",
        :website => "Website",
        :service_types => "MyText",
        :services => "MyText",
        :local_authority => "Local Authority",
        :region => "Region",
        :cqc_url => "Cqc Url",
        :cqc_location => "Cqc Location"
      ),
      CqcRecord.create!(
        :name => "Name",
        :aka => "Aka",
        :address => "Address",
        :postcode => "Postcode",
        :phone => "Phone",
        :website => "Website",
        :service_types => "MyText",
        :services => "MyText",
        :local_authority => "Local Authority",
        :region => "Region",
        :cqc_url => "Cqc Url",
        :cqc_location => "Cqc Location"
      )
    ])
  end

  it "renders a list of cqc_records" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Aka".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Postcode".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Local Authority".to_s, :count => 2
    assert_select "tr>td", :text => "Region".to_s, :count => 2
    assert_select "tr>td", :text => "Cqc Url".to_s, :count => 2
    assert_select "tr>td", :text => "Cqc Location".to_s, :count => 2
  end
end
