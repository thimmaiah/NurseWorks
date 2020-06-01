require 'rails_helper'

RSpec.describe "contacts/index", type: :view do
  before(:each) do
    assign(:contacts, [
      Contact.create!(
        :name => "Name",
        :phone => "Phone",
        :email => "Email",
        :relationship => "Relationship",
        :user_id => 2,
        :contact_type => "Contact Type"
      ),
      Contact.create!(
        :name => "Name",
        :phone => "Phone",
        :email => "Email",
        :relationship => "Relationship",
        :user_id => 2,
        :contact_type => "Contact Type"
      )
    ])
  end

  it "renders a list of contacts" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Relationship".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Contact Type".to_s, :count => 2
  end
end
