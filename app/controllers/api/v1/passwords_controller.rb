class Api::V1::PasswordsController < ApplicationController
  respond_to :json
  def create
    user = password_params[:email].present? && User.where(email: password_params[:email]).first
    if user
      user.reset_password
      head 201
    else
      raise Api::NotFound
    end
  end

  def reset
    user = User.where(email: password_params[:email], reset_password_token: password_params[:reset_password_token]).first
    if user
      if user.reset_password_expire_at > Time.now
        user.password = password_params[:password]
        user.password_confirmation = password_params[:password_confirmation]
        if user.save
          head 201
        else
          render json: { errors: user.errors }, status: 422
        end
      else
        render json: { errors: t('errors.user.reset_password_token_expeired') }, status: 422
      end
    else
      render json: { errors: t('errors.user.reset_password_token_invalid') }, status: 422
    end
  end

  private
  def password_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end