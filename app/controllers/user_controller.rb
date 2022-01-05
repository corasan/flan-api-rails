# UserController
class UserController < ApplicationController
  before_action :authorized, only: [:auto_login]

  def index
    User.find(params[:id])
  end

  def create
    puts params
    @user = User.create(user_params)
    @password = Password.create(password_params(@user))
    if @user.valid?
      render_token_and_user
    else
      render json: { message: 'Invalid email or password' }
    end
  end

  def login
    @user = User.find_by email: params[:email]
    @password = Password.find_by user_id: @user.id
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
    token = encode_token({ user_id: @user.id })
    exp = Time.now.to_i + 4 * 3600
    render json: { user: { email: @user.email, id: @user.id }, token: token, exp: exp }
  end
end
