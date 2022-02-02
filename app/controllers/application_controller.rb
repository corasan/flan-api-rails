# ApplicationController
class ApplicationController < ActionController::API
  include Firebase::Auth::Authenticable

  before_action :authenticate_user

  # before_action :authorized, only: [:decoded_token, :logged_in_user]

  def encode_token(payload)
    JWT.encode({ exp: Time.now.to_i * 60 * 60 * 24, **payload }, key, 'HS512', exp_leeway: 30)
  end

  def encode_refresh_token(payload)
    JWT.encode({ exp: Time.now.to_i * 60 * 60 * 300, **payload }, key, 'HS512', exp_leeway: 30)
  end

  def create_refresh_token(payload)
    t = RefreshToken.find_by user_id: payload[:id]
    token = encode_refresh_token(payload)
    if t.nil?
      RefreshToken.create(token: token, user_id: payload[:id]).token
    else
      t.update token: token
      t.token
    end
  end

  def decode_refresh_token(token)
    return nil unless token

    begin
      JWT.decode(token, key, true, algorithm: 'HS512')
    rescue JWT::DecodeError
      nil
    end
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    return nil unless auth_header

    token = auth_header.split(' ')[1]
    begin
      JWT.decode(token, key, true, algorithm: 'HS512')
    rescue JWT::DecodeError
      nil
    end
  end

  def logged_in_user
    puts decoded_token
    return nil unless decoded_token

    user_id = decoded_token[0]['id']
    @user = User.find_by(id: user_id)
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def key
    Rails.application.credentials.active_record_encryption.primary_key
  end
end
