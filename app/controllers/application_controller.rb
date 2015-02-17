require 'concerns/authenticable'
class ApplicationController < ActionController::Base
  respond_to :json
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Authenticable

  rescue_from Api::NotFound, with: :not_found
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

  rescue_from Api::Unauthorized do
    render json: { errors: I18n.t("permission denied")}, status: :unauthorized
  end

  protected
  def not_found
    render json: { errors: I18n.t("not_found")}, status: :not_found
  end
end
