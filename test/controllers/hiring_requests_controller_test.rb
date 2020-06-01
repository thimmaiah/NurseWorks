require 'test_helper'

class HiringRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hiring_request = hiring_requests(:one)
  end

  test "should get index" do
    get hiring_requests_url, as: :json
    assert_response :success
  end

  test "should create hiring_request" do
    assert_difference('HiringRequest.count') do
      post hiring_requests_url, params: { hiring_request: { end_date: @hiring_request.end_date, care_home_id: @hiring_request.care_home_id, num_of_hours: @hiring_request.num_of_hours, rate: @hiring_request.rate, req_type: @hiring_request.req_type, start_date: @hiring_request.start_date, start_time: @hiring_request.start_time, user_id: @hiring_request.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show hiring_request" do
    get hiring_request_url(@hiring_request), as: :json
    assert_response :success
  end

  test "should update hiring_request" do
    patch hiring_request_url(@hiring_request), params: { hiring_request: { end_date: @hiring_request.end_date, care_home_id: @hiring_request.care_home_id, num_of_hours: @hiring_request.num_of_hours, rate: @hiring_request.rate, req_type: @hiring_request.req_type, start_date: @hiring_request.start_date, start_time: @hiring_request.start_time, user_id: @hiring_request.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy hiring_request" do
    assert_difference('HiringRequest.count', -1) do
      delete hiring_request_url(@hiring_request), as: :json
    end

    assert_response 204
  end
end
