module Authenticable
  # Devise methods overwrites
  def current_user
    user = request.headers['Authorization'].present? && User.where("auth_token = ? and auth_token_expire_at < ?", request.headers['Authorization'], Time.now).first
  end
end