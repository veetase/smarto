class Api::V1::UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token, only: :update

  def show
    respond_with user = User.find(params[:id]).json_show_to_others
  end

  # def create
  #   #logger.info("subdomain:  #{request.subdomain}")
  #   user = User.new(user_params)
  #   if user.save
  #     render json: user.json_show_to_self, status: 201, location: [:api, user]
  #   else
  #     render json: { errors: user.errors }, status: 422
  #   end
  # end

  def update
    user_to_update = User.find(params[:id])
    raise Api::NotFound unless user_to_update
    raise Api::Unauthorized unless user_to_update == current_user
    if current_user.update(user_params)
      render json: current_user.json_show_to_self, status: 200, location: [:api, current_user]
    else
      render json: { errors: current_user.errors }, status: 422
    end
  end

  private
  def user_params
    params.require(:user).permit!
  end
end
