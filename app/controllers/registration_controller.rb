class RegistrationController < ApplicationController
  skip_before_action :authenticate_user

  def create
    raise ArgumentError, 'BadRequest Parameter' if payload.blank?
      @user = User.create!(user_params.merge(uid: payload['sub']))
    if @user.valid?
      UserInfo.create(user_id: @user.id, income: 0, checking: 0, savings: 0, will_save: 0, debt: 0, rent: 0)
      render json: { message: 'User created successfully', user: @user }, status: :ok
    else
      render json: { message: 'User not created', errors: @user.errors }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

  def token_from_request_headers
    request.headers['Authorization']&.split&.last
  end

  def token
    params[:token] || token_from_request_headers
  end

  def payload
    @payload ||= FirebaseIdToken::Signature.verify token
  end

  def user_exists?
    u = User.find_by(uid: payload['sub'])
    u.nil? ? false : true
  end
end
