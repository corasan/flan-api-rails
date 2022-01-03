# UserController
class UserController < ApplicationController
  def index
    User.find(params[:id])
  end

  def create
    User.create!(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :email)
  end
end
