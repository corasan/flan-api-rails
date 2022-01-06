class UserInfoControllerTest < ActionDispatch::IntegrationTest
  setup do
    params = { user: { email: 'test_user@gmail.com' }, password: 'test_user_password' }
    post '/signup', params: params
    @token = JSON.parse(@response.body)['token']
    @headers = { Authorization: "Bearer #{@token}" }
    post '/user/info', params: { user_info: { income: 2000, checking: 400, savings: 600 } }, headers: @headers
  end

  test 'can retrieve user info' do
    get '/user/info', headers: { Authorization: "Bearer #{@token}" }
    assert_response :success
  end

  test 'can update user info' do
    put '/user/info', params: { user_info: { debt: 5000 } }, headers: @headers
    assert_response :success
  end
end