# UserController
class UserController < ApplicationController
  before_action :authorized, only: [:auto_login, :index]

  def index
    res = User.find_by id: @user.id
    render json: res
  end

  def create
    @user = User.create(user_params)
    password = Password.create(password_params(@user))
    UserInfo.create(user_id: @user.id, income: 0, checking: 0, savings: 0, will_save: 0, debt: 0, rent: 0)
    if @user.valid? && password
      render_token_and_user
    else
      render json: { message: 'Invalid email or password' }
    end
  end

  def login
    @user = User.find_by email: params[:email]

    raise ActiveRecord::RecordNotFound if @user.nil?

    render_token_and_user if @user && authenticate(params[:password])

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Invalid username or password' }
  end

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.require(:user).permit([:email, :first_name, :last_name])
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
    payload = { email: @user.email, id: @user.id }
    render json: { user: payload, access_token: encode_token(payload), refresh_token: create_refresh_token(payload) }
  end
end
