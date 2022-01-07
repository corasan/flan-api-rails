class RefreshTokenController < ApplicationController
  def index
    r = RefreshToken.find_by token: params[:token]

    if !r.nil?
      decoded = decode_refresh_token(r.token)
      user = User.find_by id: decoded[0]['id']
      puts "USER -> #{user}"
      render_token_and_user(user)
    else
      render json: { message: 'Invalid refresh token' }
    end
  end

  private

  def refresh_token_params
    params.permit(:token)
  end

  def render_token_and_user(user)
    payload = { email: user.email, id: user.id }
    render json: { user: payload, access_token: encode_token(payload), refresh_token: create_refresh_token(payload) }
  end
end
