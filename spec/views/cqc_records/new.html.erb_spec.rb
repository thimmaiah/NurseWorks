require 'rails_helper'

RSpec.describe "cqc_records/new", type: :view do
  before(:each) do
    assign(:cqc_record, CqcRecord.new(
      :name => "MyString",
      :aka => "MyString",
      :address => "MyString",
      :postcode => "MyString",
      :phone => "MyString",
      :website => "MyString",
      :service_types => "MyText",
      :services => "MyText",
      :local_authority => "MyString",
      :region => "MyString",
      :cqc_url => "MyString",
      :cqc_location => "MyString"
    ))
  end

  it "renders new cqc_record form" do
    render

    assert_select "form[action=?][method=?]", cqc_records_path, "post" do

      assert_select "input#cqc_record_name[name=?]", "cqc_record[name]"

      assert_select "input#cqc_record_aka[name=?]", "cqc_record[aka]"

      assert_select "input#cqc_record_address[name=?]", "cqc_record[address]"

      assert_select "input#cqc_record_postcode[name=?]", "cqc_record[postcode]"

      assert_select "input#cqc_record_phone[name=?]", "cqc_record[phone]"

      assert_select "input#cqc_record_website[name=?]", "cqc_record[website]"

      assert_select "textarea#cqc_record_service_types[name=?]", "cqc_record[service_types]"

      assert_select "textarea#cqc_record_services[name=?]", "cqc_record[services]"

      assert_select "input#cqc_record_local_authority[name=?]", "cqc_record[local_authority]"

      assert_select "input#cqc_record_region[name=?]", "cqc_record[region]"

      assert_select "input#cqc_record_cqc_url[name=?]", "cqc_record[cqc_url]"

      assert_select "input#cqc_record_cqc_location[name=?]", "cqc_record[cqc_location]"
    end
  end
end
