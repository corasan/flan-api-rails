require "test_helper"

class SignupControllerTest < ActionDispatch::IntegrationTest
  test 'can signup' do
    post '/v2/signup', params: payload, headers: headers
    assert_response :success
  end

  test 'if user exists it should conflict' do
    post '/v2/signup', params: payload, headers: req_headers
    assert_response :conflict
  end

  private

  def payload
    {user: {first_name: 'Test', last_name: 'User'}}
  end


  def headers
    {Authorization: "Bearer #{create_token(token_payload)}"}
  end

  def token_payload
    {
      "iss"=>"https://securetoken.google.com/flan-45128",
      "aud"=>"flan-45128",
      "auth_time"=>Time.now.to_i,
      "user_id"=>"LhQtWkV800ZaIJsrf3o6dycCxvr2",
      "sub"=>"LhQtWkV800ZaIJsrf3o6dycCxvr2",
      "iat"=>Time.now.to_i,
      "exp"=>Time.now.tomorrow.to_i,
      "email"=>"test1@flanapp.com",
      "email_verified"=>false,
      "firebase"=>{
        "identities"=>{
          "email"=>["test1@flanapp.com"]
        },
        "sign_in_provider"=>"password"
      }
    }
  end
end
