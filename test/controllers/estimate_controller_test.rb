require "test_helper"

class EstimateControllerTest < ActionDispatch::IntegrationTest
  test 'Can get estimate data' do
    get '/v2/estimate', headers: req_headers
    assert_response :ok
  end

  test 'Retrieving estimate without user info returns error' do
    get '/v2/estimate', headers: req_headers_three
    assert_response :no_content
  end

  test 'Can get chart data' do
    get '/v2/estimate/chart', headers: req_headers
    assert_response :ok
  end

  test 'Retrieving estimate chart data returns error' do
    get '/v2/estimate/chart', headers: req_headers_three
  end
end
