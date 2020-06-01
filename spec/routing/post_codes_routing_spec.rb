require "rails_helper"

RSpec.describe PostCodesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/post_codes").to route_to("post_codes#index")
    end

    it "routes to #new" do
      expect(:get => "/post_codes/new").to route_to("post_codes#new")
    end

    it "routes to #show" do
      expect(:get => "/post_codes/1").to route_to("post_codes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/post_codes/1/edit").to route_to("post_codes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/post_codes").to route_to("post_codes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/post_codes/1").to route_to("post_codes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/post_codes/1").to route_to("post_codes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/post_codes/1").to route_to("post_codes#destroy", :id => "1")
    end

  end
end
