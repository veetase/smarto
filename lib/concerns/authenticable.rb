module Authenticable
  # Devise methods overwrites
  def current_user
    user = request.headers['Authorization'].present? && User.find_by(auth_token: request.headers['Authorization'])
  end
end