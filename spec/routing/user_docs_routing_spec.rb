require "rails_helper"

RSpec.describe UserDocsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/user_docs").to route_to("user_docs#index")
    end

    it "routes to #new" do
      expect(:get => "/user_docs/new").to route_to("user_docs#new")
    end

    it "routes to #show" do
      expect(:get => "/user_docs/1").to route_to("user_docs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/user_docs/1/edit").to route_to("user_docs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/user_docs").to route_to("user_docs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_docs/1").to route_to("user_docs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_docs/1").to route_to("user_docs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_docs/1").to route_to("user_docs#destroy", :id => "1")
    end

  end
end
