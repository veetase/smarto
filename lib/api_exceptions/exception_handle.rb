module ExceptionHandle
  def not_found
    render json: { errors: I18n.t("exception.not_found")}, status: :not_found
  end

  def invalid_format
    render json: { errors: I18n.t("exception.request_format_must_be_json")}, status: :not_acceptable
  end

  def unauth
    render json: { errors: I18n.t("exception.permission_denied")}, status: :unauthorized
  end

  def invalid_value
    render json: { errors: I18n.t("exception.invalid_value")}, status: :bad_request
  end
end
