require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  test 'can retrieve user' do
    get'/v2/user', headers: req_headers
    assert_response :success
  end
end
