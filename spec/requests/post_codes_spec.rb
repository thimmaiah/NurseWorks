require 'rails_helper'

RSpec.describe "PostCodes", type: :request do
  describe "GET /post_codes" do
    it "works! (now write some real specs)" do
      get post_codes_path
      expect(response).to have_http_status(200)
    end
  end
end
