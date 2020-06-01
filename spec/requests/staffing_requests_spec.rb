require 'rails_helper'

RSpec.describe "StaffingRequests", type: :request do
  describe "GET /staffing_requests" do
    it "works! (now write some real specs)" do
      get staffing_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
