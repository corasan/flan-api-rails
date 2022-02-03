class LoginController < ApplicationController
  skip_before_action :authenticate_user

  def index
    raise ArgumentError, 'BadRequest Parameter' if payload.blank?

    @user = User.find_by uid: payload['sub']
    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
    else
      render json: @user, status: :ok
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def token_from_request_headers
    request.headers['Authorization']&.split&.last
  end

  def token
    params[:token] || token_from_request_headers
  end

  def payload
    @payload ||= FirebaseIdToken::Signature.verify token
  end
end
