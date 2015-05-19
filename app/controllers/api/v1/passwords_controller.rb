class Api::V1::PasswordsController < ApplicationController
  respond_to :json
  def create
    user = password_params[:phone].present? && User.where(phone: password_params[:phone]).first
    if user
      user.reset_password
      head 201
    else
      raise Api::NotFound
    end
  end

  def reset
    user = User.where(phone: password_params[:phone], reset_password_token: password_params[:reset_password_token]).first
    if user
      if user.reset_password_expire_at > Time.now
        user.password = password_params[:password]
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
    params.require(:user).permit(:phone, :password, :reset_password_token)
  end
end
