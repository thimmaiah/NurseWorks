require 'rails_helper'

RSpec.describe "UserDocs", type: :request do
  describe "GET /user_docs" do
    it "works! (now write some real specs)" do
      get user_docs_path
      expect(response).to have_http_status(200)
    end
  end
end
