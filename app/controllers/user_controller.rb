# UserController
class UserController < ApplicationController
  before_action :authorized, only: [:auto_login]

  def index
    User.find(params[:id])
  end

  def create
    @user = User.create(user_params)
    password = Password.create(password_params(@user))
    if @user.valid? && password
      render_token_and_user
    else
      render json: { message: 'Invalid email or password' }
    end
  end

  def login
    @user = User.find_by email: params[:email]
    if @user && authenticate(params[:password])
      render_token_and_user
    else
      render json: { error: 'Invalid username or password' }
    end
  end

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def password_params(user)
    ActionController::Parameters.new(
      password: { value: params[:password], user_id: user.id }
    ).require(:password).permit(:user_id, :value)
  end

  def authenticate(password)
    encrypted_pass = Password.find_by user_id: @user.id
    puts "USER PASSWORD IS ENCRYPTED: #{encrypted_pass.encrypted_attribute?(:value)}"
    encrypted_pass.value == password
  end

  def render_token_and_user
    render json: { user: { email: @user.email, id: @user.id }, access_token: encode_token, refresh_token: create_refresh_token }
  end
end
