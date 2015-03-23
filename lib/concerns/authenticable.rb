module Authenticable
  # Devise methods overwrites
  def current_user
    user = request.headers['Authorization'].present? && User.where(:auth_token=> request.headers['Authorization'], :auth_token_expire_at.gt => Time.now).first
  end
end