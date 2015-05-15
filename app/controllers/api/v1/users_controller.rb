class Api::V1::UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token, only: [:update, :change_phone, :reset_phone]

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
    byebug
    if current_user.update(user_params)

      render json: current_user.json_show_to_self, status: 200, location: [:api, current_user]
    else
      render json: { errors: current_user.errors }, status: 422
    end
  end

  def change_phone
    current_user.change_phone
    head 200
  end

  def reset_phone
    confirm_token = params[:confirm_token]
    if current_user.valid_confirm_token(confirm_token)
      current_user.phone = params[:phone]
      current_user.confirmation_token = nil
      current_user.confirmation_expire_at = nil

      if current_user.save
        head 204
      else
        render json: { errors: current_user.errors }, status: 422
      end
    else
      render json: { errors: I18n.t('invalid_confirmation_token') }, status: 422
    end
  end

  private
  def user_params
    params.require("user").permit(:nick_name, :avatar, :gender, :age, :figure, tags:[])
  end
end
