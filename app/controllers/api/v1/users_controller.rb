class Api::V1::UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token, only: :update

  def show
    respond_with user = User.find(params[:id]).as_json(only: :avatar)
  end

  def create
    logger.info("#{request.subdomain}")
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    if current_user.update(user_params)
      render json: current_user, status: 200, location: [:api, current_user]
    else
      render json: { errors: current_user.errors }, status: 422
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head 204
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
