class Api::V1::SessionsController < ApplicationController
  respond_to :json, :html
  def create
    user_password = session_params[:password]
    user_email = session_params[:email]
    user = user_email.present? && User.find_by(email: user_email)
    if user.valid_password? user_password
      #sign_in(user, store: false)
      user.generate_authentication_token!
      user.save
      render json: user.as_json(only: [:auth_token, :avatar]), status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    user = User.where(auth_token: params[:id]).first
    if user
      user.generate_authentication_token!
      user.save
    end
    head 204
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
