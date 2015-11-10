require 'uti/uc_sms'
class Api::V1::UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token, only: [:update, :change_phone, :reset_phone]

  def show
    respond_with user = User.find(params[:id]).json_show_to_others
  end

  def check_phone
    phone = params[:phone]
    registed = false
    raise Api::ParameterInvalid unless phone.present? && User.valid_phone_format.match(phone)
    sign = nil
    if User.where(phone: phone).first
      registed = true
    else
      sms = UcSms.new
      sign = sms.create_sign(phone)
    end

    render json: { registed: registed, sign: sign }
  end

  def create
    user = User.new
    user.phone = params[:user][:phone]
    user.password = params[:user][:password]

    user.confirmed_at = Time.now
    if user.save
      render json: user.json_show_to_self, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    if current_app_user.update(user_params)
      head :ok
    else
      render json: { errors: current_app_user.errors }, status: 422
    end
  end

  def change_phone
    @user = current_app_user #for test case
    @user.change_phone
    head 200
  end

  def reset_phone
    confirm_token = params[:user][:confirm_token]
    @user = current_app_user

    if @user.valid_confirm_token?(confirm_token)
      @user.phone = params[:user][:phone]
      @user.confirmation_token = nil
      @user.confirmation_expire_at = nil

      if @user.save
        head 204
      else
        render json: { errors: current_app_user.errors }, status: 422
      end
    else
      render json: { errors: I18n.t('invalid_confirmation_token') }, status: 422
    end
  end

  private
  def user_params
    # remove age when app version is high enough
    params.require("user").permit(:nick_name, :avatar, :gender, :age, :birth_date, :figure, tags:[])
  end
end
