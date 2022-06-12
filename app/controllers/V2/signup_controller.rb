module V2
  class SignupController < ApplicationController
    skip_before_action :is_authorized

    def create
      p = token_payload
      user = User.create({**signup_params, email: p['email'], uid: p['uid']})
      if !user.valid?
        render json: {message: 'A user with this email address already exists.'}, status: :conflict
      else
        render json: {data: user}, status: :ok
      end
    end

    def signup_params
      params.permit(:first_name, :last_name)
    end

    private

    def token_payload
      token = request.headers['Authorization']&.split&.last
      FirebaseIdToken::Signature.verify(token)
    end
  end
end