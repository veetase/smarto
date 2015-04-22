require 'concerns/authenticable'
require 'api_exceptions/exception_handle'
class ApplicationController < ActionController::Base
  include ExceptionHandle
  respond_to :json, :html
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include Authenticable

  rescue_from Api::NotFound, ActionController::RoutingError, ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::UnknownFormat, with: :invalid_format
  rescue_from Api::Unauthorized, with: :unauth
  rescue_from ActionController::ParameterMissing, ActiveRecord::RecordInvalid, with: :invalid_value

  protected

  def authenticate_with_token
    raise Api::Unauthorized unless current_user
  end
end
