class User
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :spots
  before_create :generate_authentication_token!
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,                   type: String, default: ""
  field :encrypted_password,      type: String, default: ""
  field :auth_token,              type: String, default: ""
  field :auth_token_expire_at,    type: Time
  field :avatar,                  type: String, default: ""

  ## Recoverable
  field :reset_password_token,    type: String
  field :reset_password_sent_at,  type: Time

  ## Confirmable
  field :confirmation_token,      type: String, default: ""
  field :confirmed_at,            type: Time
  field :confirmation_sent_at,    type: Time
  field :unconfirmed_email,       type: String

  ## Rememberable
  field :remember_created_at,     type: Time

  ## Trackable
  field :sign_in_count,           type: Integer, default: 0
  field :current_sign_in_at,      type: Time
  field :last_sign_in_at,         type: Time
  field :current_sign_in_ip,      type: String
  field :last_sign_in_ip,         type: String

  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :confirmation_token, :auth_token, uniqueness: true
  
  index({ email: 1, auth_token: 1 }, { unique: true })
  #to ensure auto token is unique
  def generate_authentication_token!
    byebug
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.where(auth_token: auth_token).exists?
    self.auth_token_expire_at = Config.user.login_expire_days.days.from_now
  end
end
