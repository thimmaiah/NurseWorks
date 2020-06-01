require 'rails_helper'

RSpec.describe "referrals/show", type: :view do
  before(:each) do
    @referral = assign(:referral, Referral.create!(
      :first_name => "First Name",
      :last_name => "Last Name",
      :email => "Email",
      :role => "Role",
      :user_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Role/)
    expect(rendered).to match(/2/)
  end
end
