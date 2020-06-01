require 'rails_helper'

RSpec.describe "RecurringRequests", type: :request do
  describe "GET /recurring_requests" do
    it "works! (now write some real specs)" do
      get recurring_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
