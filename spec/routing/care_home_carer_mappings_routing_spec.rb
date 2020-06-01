require "rails_helper"

RSpec.describe CareHomeCarerMappingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/care_home_carer_mappings").to route_to("care_home_carer_mappings#index")
    end

    it "routes to #new" do
      expect(:get => "/care_home_carer_mappings/new").to route_to("care_home_carer_mappings#new")
    end

    it "routes to #show" do
      expect(:get => "/care_home_carer_mappings/1").to route_to("care_home_carer_mappings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/care_home_carer_mappings/1/edit").to route_to("care_home_carer_mappings#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/care_home_carer_mappings").to route_to("care_home_carer_mappings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/care_home_carer_mappings/1").to route_to("care_home_carer_mappings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/care_home_carer_mappings/1").to route_to("care_home_carer_mappings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/care_home_carer_mappings/1").to route_to("care_home_carer_mappings#destroy", :id => "1")
    end
  end
end
