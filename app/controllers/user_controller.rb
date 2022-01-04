# UserController
class UserController < ApplicationController
  before_action :authorized, only: [:auto_login]
  def index
    User.find(params[:id])
  end

  def create
    @user = User.create!(user_params)
    if @user.valid?
      render_token_and_user(@user)
    else
      render json: { message: 'Invalid email or password' }
    end
  end

  def logged_in?
    @user = User.find_by email: params[:email]
    if @user && user.authenticate(params[:password])
      render_token_and_user(@user)
    else
      render json: { error: 'Invalid username or password' }
    end
  end

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :email)
  end

  def authenticate(password)
    user = @user.decrypt
    user.password == password
  end

  def render_token_and_user(user)
    token = encode_token({ user_id: user.id })
    render json: { user: { email: user.email, id: user.id }, token: token }
  end
end
