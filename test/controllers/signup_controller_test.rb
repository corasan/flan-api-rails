require "test_helper"

class SignupControllerTest < ActionDispatch::IntegrationTest
  test 'can signup' do
    post '/v2/signup', params: payload, headers: headers
    assert_response :success
  end

  test 'if user exists it should conflict' do
    post '/v2/signup', params: payload, headers: headers
    post '/v2/signup', params: payload, headers: headers
    assert_response :conflict
  end

  private

  def create_token
    JWT.encode token_payload, OpenSSL::PKey::RSA.new(FirebaseIdToken::Testing::Certificates.private_key), 'RS256'
  end

  def payload
    {first_name: 'Test', last_name: 'User'}
  end

  def token_payload
    {
      "iss"=>"https://securetoken.google.com/flan-45128",
      "aud"=>"flan-45128",
      "auth_time"=>1651423513,
      "user_id"=>"LhQtWkV800ZaIJsrf3o6dycCxvr2",
      "sub"=>"LhQtWkV800ZaIJsrf3o6dycCxvr2",
      "iat"=>1651423513,
      "exp"=>1651427113,
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

  def headers
    {Authorization: "Bearer #{create_token}"}
  end
end
