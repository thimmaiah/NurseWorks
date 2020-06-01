require 'rails_helper'

RSpec.describe "contacts/new", type: :view do
  before(:each) do
    assign(:contact, Contact.new(
      :name => "MyString",
      :phone => "MyString",
      :email => "MyString",
      :relationship => "MyString",
      :user_id => 1,
      :contact_type => "MyString"
    ))
  end

  it "renders new contact form" do
    render

    assert_select "form[action=?][method=?]", contacts_path, "post" do

      assert_select "input#contact_name[name=?]", "contact[name]"

      assert_select "input#contact_phone[name=?]", "contact[phone]"

      assert_select "input#contact_email[name=?]", "contact[email]"

      assert_select "input#contact_relationship[name=?]", "contact[relationship]"

      assert_select "input#contact_user_id[name=?]", "contact[user_id]"

      assert_select "input#contact_contact_type[name=?]", "contact[contact_type]"
    end
  end
end
