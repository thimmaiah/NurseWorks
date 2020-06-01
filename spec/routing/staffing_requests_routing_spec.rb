require "rails_helper"

RSpec.describe StaffingRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/staffing_requests").to route_to("staffing_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/staffing_requests/new").to route_to("staffing_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/staffing_requests/1").to route_to("staffing_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/staffing_requests/1/edit").to route_to("staffing_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/staffing_requests").to route_to("staffing_requests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/staffing_requests/1").to route_to("staffing_requests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/staffing_requests/1").to route_to("staffing_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/staffing_requests/1").to route_to("staffing_requests#destroy", :id => "1")
    end

  end
end
