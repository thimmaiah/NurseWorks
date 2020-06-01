require "rails_helper"

RSpec.describe AgencyUserMappingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/agency_user_mappings").to route_to("agency_user_mappings#index")
    end

    it "routes to #new" do
      expect(:get => "/agency_user_mappings/new").to route_to("agency_user_mappings#new")
    end

    it "routes to #show" do
      expect(:get => "/agency_user_mappings/1").to route_to("agency_user_mappings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/agency_user_mappings/1/edit").to route_to("agency_user_mappings#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/agency_user_mappings").to route_to("agency_user_mappings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/agency_user_mappings/1").to route_to("agency_user_mappings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/agency_user_mappings/1").to route_to("agency_user_mappings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/agency_user_mappings/1").to route_to("agency_user_mappings#destroy", :id => "1")
    end
  end
end
