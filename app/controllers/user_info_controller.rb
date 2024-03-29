# UserInfoController
class UserInfoController < ApplicationController
  before_action :authenticate_user
  before_action :auth_payload

  def index
    render json: info
  end

  def create
    if !info.nil?
      render json: info
    else
      obj = { user_id: @user.id, **user_info_params }
      render json: UserInfo.create(obj)
    end
  end

  def update
    info.update(user_info_params)
    info.save
    render json: info
  end

  private

  def user_info_params
    params.require(:user_info).permit([:income, :checking, :rent, :savings, :debt, :will_save])
  end

  def info
    UserInfo.find_by user_id: @user.id
  end
end
