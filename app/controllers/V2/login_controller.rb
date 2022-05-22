module V2
  class LoginController < ApplicationController
    def index
      raise ArgumentError, 'Bad argument error' if @token_payload.nil?

      puts "User => #{@user}"

      if @user.nil?
        render json: {error: 'User not found'}, status: :not_found
      else
        render json: @user, status: :ok
      end
    end
  end
end