require 'rails_helper'

RSpec.describe "contacts/show", type: :view do
  before(:each) do
    @contact = assign(:contact, Contact.create!(
      :name => "Name",
      :phone => "Phone",
      :email => "Email",
      :relationship => "Relationship",
      :user_id => 2,
      :contact_type => "Contact Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Relationship/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Contact Type/)
  end
end
