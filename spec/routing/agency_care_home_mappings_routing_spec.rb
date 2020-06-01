require "rails_helper"

RSpec.describe AgencyCareHomeMappingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/agency_care_home_mappings").to route_to("agency_care_home_mappings#index")
    end

    it "routes to #new" do
      expect(:get => "/agency_care_home_mappings/new").to route_to("agency_care_home_mappings#new")
    end

    it "routes to #show" do
      expect(:get => "/agency_care_home_mappings/1").to route_to("agency_care_home_mappings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/agency_care_home_mappings/1/edit").to route_to("agency_care_home_mappings#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/agency_care_home_mappings").to route_to("agency_care_home_mappings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/agency_care_home_mappings/1").to route_to("agency_care_home_mappings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/agency_care_home_mappings/1").to route_to("agency_care_home_mappings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/agency_care_home_mappings/1").to route_to("agency_care_home_mappings#destroy", :id => "1")
    end
  end
end
