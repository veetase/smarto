class Api::V1::AddressesController < ApplicationController
  before_action :authenticate_with_token

  def index
    respond_with current_app_user.addresses
  end

  def show
    respond_with Address.find(params[:id])
  end

  def create
    address = current_app_user.addresses.build(address_params)
    if address.save
      render json: address, status: 201
    else
      render json: { errors: address.errors }, status: 422
    end
  end

  def update
    address = Address.find(params[:id])
    if address.update(address_params)
      render json: address, status: 200
    else
      render json: { errors: address.errors }, status: 422
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    head 204
  end

  private

  def address_params
    params.require(:address).permit!
  end
end
