class Api::V1::PasswordsController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token, except: [:create]
  def create
    user = password_params[:email].present? && User.where(email: password_params[:email]).first
    if user
      user.reset_password
      head 201
    else
      raise Api::NotFound
    end
  end

  private
  def password_params
    params.require(:user).permit(:email)
  end
end