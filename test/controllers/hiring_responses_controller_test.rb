require 'test_helper'

class HiringResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hiring_response = hiring_responses(:one)
  end

  test "should get index" do
    get hiring_responses_url, as: :json
    assert_response :success
  end

  test "should create hiring_response" do
    assert_difference('HiringResponse.count') do
      post hiring_responses_url, params: { hiring_response: { hiring_request_id: @hiring_response.hiring_request_id, notest: @hiring_response.notest, user_id: @hiring_response.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show hiring_response" do
    get hiring_response_url(@hiring_response), as: :json
    assert_response :success
  end

  test "should update hiring_response" do
    patch hiring_response_url(@hiring_response), params: { hiring_response: { hiring_request_id: @hiring_response.hiring_request_id, notest: @hiring_response.notest, user_id: @hiring_response.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy hiring_response" do
    assert_difference('HiringResponse.count', -1) do
      delete hiring_response_url(@hiring_response), as: :json
    end

    assert_response 204
  end
end
