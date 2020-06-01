require 'test_helper'

class CareHomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_home = care_homes(:one)
  end

  test "should get index" do
    get care_homes_url, as: :json
    assert_response :success
  end

  test "should create care_home" do
    assert_difference('CareHome.count') do
      post care_homes_url, params: { care_home: { address: @care_home.address, base_rate: @care_home.base_rate, locality: @care_home.locality, name: @care_home.name, postcode: @care_home.postcode, street: @care_home.street, town: @care_home.town } }, as: :json
    end

    assert_response 201
  end

  test "should show care_home" do
    get care_home_url(@care_home), as: :json
    assert_response :success
  end

  test "should update care_home" do
    patch care_home_url(@care_home), params: { care_home: { address: @care_home.address, base_rate: @care_home.base_rate, locality: @care_home.locality, name: @care_home.name, postcode: @care_home.postcode, street: @care_home.street, town: @care_home.town } }, as: :json
    assert_response 200
  end

  test "should destroy care_home" do
    assert_difference('CareHome.count', -1) do
      delete care_home_url(@care_home), as: :json
    end

    assert_response 204
  end
end
