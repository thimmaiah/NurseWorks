require 'rails_helper'

RSpec.describe "cqc_records/show", type: :view do
  before(:each) do
    @cqc_record = assign(:cqc_record, CqcRecord.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Aka/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Postcode/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Local Authority/)
    expect(rendered).to match(/Region/)
    expect(rendered).to match(/Cqc Url/)
    expect(rendered).to match(/Cqc Location/)
  end
end
