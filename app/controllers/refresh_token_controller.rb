class RefreshTokenController < ApplicationController
  before_action :authorized
  def index
    r = RefreshToken.find_by token: auth_header.split(' ')[1]

    if !r.token.nil?
      render json: { user: { email: @user.email, id: @user.id }, access_token: encode_token, refresh_token: create_refresh_token }
    else
      render json: { message: 'Invalid refresh token' }
    end
  end

  private

  def refresh_token_params
    params.permit(:token)
  end

  def render_token_and_user
    render json: { user: { email: @user.email, id: @user.id }, access_token: encode_token, refresh_token: create_refresh_token }
  end
end
