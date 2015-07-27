module ExceptionHandle
  def not_found
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.any  { head :not_found }
    end
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
