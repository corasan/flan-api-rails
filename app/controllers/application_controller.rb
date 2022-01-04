# ApplicationController
class ApplicationController < ActionController::API
  before_action :authorized
  @key = Rails.application.credentials.active_record_encryption.primary_key

  def encode_token(payload)
    JWT.encode(payload, @key)
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    return nil unless auth_header

    token = auth_header.split(' ')[1]
    # header: { 'Authorization': 'Bearer <token>' }
    begin
      JWT.decode(token, @key, true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def logged_in_user
    return nil unless decoded_token

    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end
