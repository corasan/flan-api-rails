module V2
  class UserController < ApplicationController
    def index
      render json: @user, status: :ok
    end

    def update
      @user.update(user_params)
      @user.save
      render @user, status: :ok
    end

    private

    def user_params
      params.permit([:setup_completed])
    end
  end
end
