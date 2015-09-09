class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token, except: :complete_order
  before_action :find_order, only: :show, :prepare_pay, :complete_order
  def index
    render json: current_app_user.orders
  end

  def show
    respond_with @order.as_json(include: { products: { only: [:id, :title, :description, :price]}})
  end

  # order checkout out
  def create
    order = current_app_user.orders.build
    order.build_placements_with_product_ids_and_quantities(params[:order][:product_ids_and_quantities])
    order.go_to_status Order::PENDING

    if order.save
      order.reload #we reload the object so the response displays the product objects
      #send sms message
      render json: order.as_json(include: :products), status: 201, location: [:api, current_app_user, order]
    else
      render json: { errors: order.errors }, status: 422
    end
  end

  def use_coupon
    # TODO: use coupon code to reset order total price
  end

  def get_charge
    charge = @order.create_charge(params[:order][:channel], request.remote_ip, params[:order][:currency])
    render json: {charge: charge}, status: 200
  end

  def complete_order
    order = Order.where(order_no: params[:data][:object][:order_no]).first
    raise Api::NotFound unless order

    if params[:data][:object][:paid]
      order.go_to_status Order::COMPLETED
    elsif params[:data][:object][:paid][:refunded]
      order.go_to_status Order::REFUNDED
    end

    head :ok if order.save!
  end

  def cancel
    @order.go_to_status Order::CANCELED
    head :ok if @order.save
  end

  private
    def order_params
      params.require(:order).permit(:product_ids => [])
    end

    def find_order
      @order = current_app_user.orders.includes(:products).find(params[:id])
    end
end
