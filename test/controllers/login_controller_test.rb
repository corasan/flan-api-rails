require "test_helper"

class LoginControllerTest < ActionDispatch::IntegrationTest
  test 'retrieve user from token' do
    get '/v2/login', headers: req_headers
    assert_response :success
  end
end
