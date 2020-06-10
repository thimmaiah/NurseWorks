require 'rails_helper'

RSpec.describe "CareHomeNurseMappings", type: :request do
  describe "GET /care_home_nurse_mappings" do
    it "works! (now write some real specs)" do
      get care_home_nurse_mappings_path
      expect(response).to have_http_status(200)
    end
  end
end
