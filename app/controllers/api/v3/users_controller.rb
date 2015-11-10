require 'uti/uc_sms'
class Api::V3::UsersController < ApplicationController
  respond_to :json

  def check_phone
    phone = params[:phone]
    raise Api::ParameterInvalid unless phone.present? && User.valid_phone_format.match(phone)
    sign = nil
    expire_seconds = BxgConfig.user.confirmation_expire_secondes.to_i

    if User.where(phone: phone).first
      registed = true
    else
      registed = false
      set_confirm_token(phone, expire_seconds)
    end

    render json: { registed: registed, expire_seconds: expire_seconds - 60}
  end

  def create
    user = User.new
    user.phone = params[:user][:phone]
    user.password = params[:user][:password]

    if verify_confirm_token(user.phone, params[:user][:confirm_token])
      $redis.set(confirm_key_of_phone(user.phone), nil)
      user.confirmed_at = Time.now
      if user.save
        render json: user.json_show_to_self, status: 201, location: [:api, user]
      else
        render json: { errors: user.errors }, status: 422
      end
    else
      render json: { errors: {confirm_token: 'timeout'} }, status: 422
    end
  end

  def verify_confirm
    matched = false

    if verify_confirm_token(params[:user][:phone], params[:user][:confirm_token])
      matched = true
    end

    render json: { matched: matched}
  end

  private
  def set_confirm_token(phone, expire_seconds)
    code = [*"0".."9"].sample(4).join
    $redis.set(confirm_key_of_phone(phone), code)
    $redis.expire(confirm_key_of_phone(phone), expire_seconds)
    UcSmsJob.perform_async(phone, code, "register", expire_seconds)
  end

  def verify_confirm_token(phone, token)
    $redis.get(confirm_key_of_phone(phone)) == token
  end

  def confirm_key_of_phone(phone)
    "#{phone}_confirmation_token"
  end
end
