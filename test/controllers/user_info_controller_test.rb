require "test_helper"

class UserInfoControllerTest < ActionDispatch::IntegrationTest
  test 'can retrieve user info' do
    get '/v2/user_info', headers: req_headers
    assert_response :success
  end

  test 'can update user info' do
    put '/v2/user_info', params: { debt: 5000 }, headers: req_headers
    assert_response :success
  end

  test 'can update checking and savings' do
    put '/v2/user_info', params: { checking: 2000, savings: 6000 }, headers: req_headers
    assert_response :success
  end

  test 'return error message if user_info doesnt exist' do
    get '/v2/user_info', headers: req_headers
    assert_response :success
  end

  test 'can create user info' do
    post '/v2/user_info', headers: req_headers_three
    assert_response :success
  end
end
