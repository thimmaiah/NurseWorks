require 'rails_helper'

RSpec.describe "AgencyUserMappings", type: :request do
  describe "GET /agency_user_mappings" do
    it "works! (now write some real specs)" do
      get agency_user_mappings_path
      expect(response).to have_http_status(200)
    end
  end
end
