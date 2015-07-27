class Api::V1::VouchersController < ApplicationController
  before_action :authenticate_with_token
  def index
    render json: current_app_user.vouchers
  end

  def active
    code = params[:voucher]
    voucher = Voucher.where(code: code, status: Voucher::Status::FRESH).first
    raise Api::ParameterInvalid unless voucher
    head 204 if current_app_user.vouchers << voucher
  end
end
