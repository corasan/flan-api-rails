module V2
  class SignupController < ApplicationController
    skip_before_action :is_authorized

    def create
      p = token_payload
      user = User.create({**signup_params, email: p['email'], uid: p['uid']})
      create_user_info
      if !user.valid?
        render json: {message: 'A user with this email address already exists.'}, status: :conflict
      else
        render json: {data: user}, status: :ok
      end
    end

    def signup_params
      params.require('user').permit(:first_name, :last_name)
    end

    private

    def create_user_info
      UserInfo.create({user_id: @user.id})
    end

    def token_payload
      token = params[:token] || request.headers['Authorization']&.split&.last
      FirebaseIdToken::Signature.verify(token)
    end
  end
end