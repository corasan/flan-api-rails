module V2
  class UserInfoController < ApplicationController
    def index
      render json: info, status: :ok
    end

    def create
      if !info.nil?
        render json: info, status: :ok
      else
        obj = {user_id: @user.id, **user_info_params}
        render json: User.info.create(obj), status: :ok
      end
    end

    def update
      info.update(user_info_params)
      info.save
      render json: info, status: :ok
    end

    private

    def user_info_params
      params.permit([:income, :checking, :rent, :savings, :debt, :will_save])
    end

    def info
      UserInfo.find_by user_id: @user.id
    end
  end
end
