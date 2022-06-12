# ApplicationController
class ApplicationController < ActionController::API
  include Firebase::Auth::Authenticable

  before_action :authenticate_user
  before_action :is_authorized

  def auth_header
    request.headers['Authorization']&.split&.last
  end

  def authenticate_request
    FirebaseIdToken::Signature.verify auth_header
  end

  def authenticate_user
    @token_payload = FirebaseIdToken::Signature.verify auth_header
    @user = User.find_by(uid: @token_payload['user_id'])
  end

  def current_user
    @user
  end

  def is_authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless @user
  end
end
