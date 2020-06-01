require 'rails_helper'

RSpec.describe "AgencyCareHomeMappings", type: :request do
  describe "GET /agency_care_home_mappings" do
    it "works! (now write some real specs)" do
      get agency_care_home_mappings_path
      expect(response).to have_http_status(200)
    end
  end
end
