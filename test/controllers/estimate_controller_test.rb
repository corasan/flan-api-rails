require "test_helper"

class EstimateControllerTest < ActionDispatch::IntegrationTest
  test 'Can get estimate data' do
    get '/v2/estimate', headers: req_headers
    assert_response :ok
  end

  test 'Can get chart data' do
    get '/v2/estimate/chart', headers: req_headers
    assert_response :ok
  end
end
