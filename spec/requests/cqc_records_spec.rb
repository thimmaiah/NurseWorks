require 'rails_helper'

RSpec.describe "CqcRecords", type: :request do
  describe "GET /cqc_records" do
    it "works! (now write some real specs)" do
      get cqc_records_path
      expect(response).to have_http_status(200)
    end
  end
end
