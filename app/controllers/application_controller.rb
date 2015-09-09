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
  rescue_from ActionController::ParameterMissing, ActiveRecord::RecordInvalid, Api::ParameterInvalid, with: :invalid_value

  def authenticate_admin!
    if current_user
      current_user.has_role?(:admin)
    else
      redirect_to new_user_session_path
    end
  end

  def authenticate_app_admin!
    raise Api::Unauthorized unless current_app_user.has_role?(:admin)
  end

  def access_denied(exception)
    raise ActionController::RoutingError.new('Not Found')
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected

  def authenticate_with_token
    raise Api::Unauthorized unless current_app_user
  end

  def after_sign_in_path_for(resource)
    session["user_return_to"] || admin_root_path
  end
end
