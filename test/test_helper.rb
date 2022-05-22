ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  #
  setup do
    FirebaseIdToken.test!
  end

  def req_headers
    {Authorization: "Bearer #{create_token}"}
  end

  def create_token
    JWT.encode user_two_token_payload, OpenSSL::PKey::RSA.new(FirebaseIdToken::Testing::Certificates.private_key), 'RS256'
  end

  def user_two_token_payload
    {
      "iss"=>"https://securetoken.google.com/flan-45128",
      "aud"=>"flan-45128",
      "auth_time"=>Time.now.to_i,
      "user_id"=>"WXAlQTGhWVQFRVPSdfU6IkaJIPc2",
      "sub"=>"WXAlQTGhWVQFRVPSdfU6IkaJIPc2",
      "iat"=>Time.now.to_i,
      "exp"=>Time.now.tomorrow.to_i,
      "email"=>"test2@flanapp.com",
      "email_verified"=>false,
      "firebase"=>{
        "identities"=>{
          "email"=>["test2@flanapp.com"]
        },
        "sign_in_provider"=>"password"
      }
    }
  end
end
