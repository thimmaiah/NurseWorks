require "rails_helper"

RSpec.describe CqcRecordsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/cqc_records").to route_to("cqc_records#index")
    end

    it "routes to #new" do
      expect(:get => "/cqc_records/new").to route_to("cqc_records#new")
    end

    it "routes to #show" do
      expect(:get => "/cqc_records/1").to route_to("cqc_records#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/cqc_records/1/edit").to route_to("cqc_records#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/cqc_records").to route_to("cqc_records#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/cqc_records/1").to route_to("cqc_records#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/cqc_records/1").to route_to("cqc_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/cqc_records/1").to route_to("cqc_records#destroy", :id => "1")
    end

  end
end
