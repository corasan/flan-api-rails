module V2
  class SignupController < ApplicationController
    def create
      p = token_payload
      user = User.create({**signup_params, email: p['email'], uid: p['user_id'], setup_completed: false})
      create_user_info(user)
      if !user.valid?
        render json: {message: 'A user with this email address already exists.'}, status: :conflict
      else
        render json: user, status: :ok
      end
    end

    def signup_params
      params.require('user').permit(:first_name, :last_name)
    end

    private

    def create_user_info(user)
      UserInfo.create({user_id: user.id})
    end

    def token_payload
      token = request.headers['Authorization']&.split&.last
      FirebaseIdToken::Signature.verify(token)
    end
  end
end