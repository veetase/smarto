class User
  include Mongoid::Document
  include Mongoid::Timestamps
  #has_many :spots
  embeds_one :body_condition
  accepts_nested_attributes_for :body_condition
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
  field :nick_name,               type: String, default: ""
  field :avatar,                  type: String, default: ""
  field :gender,                  type: Integer, default: 0

  ## Recoverable
  field :reset_password_token,    type: String
  field :reset_password_send_at,  type: Time
  field :reset_password_expire_at,  type: Time

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

  module Gender
    UNDEFINED = 0
    MALE      = 1
    FEMALE    = 2
  end


  validates :auth_token, uniqueness: true
  validates_numericality_of :gender, only_integer: true, greater_than: -1, less_than: 3
  
  
  index({ email: 1, auth_token: 1 }, { unique: true })
  #to ensure auto token is unique
  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.where(auth_token: auth_token).exists?
    self.auth_token_expire_at = BxgConfig.user.login_expire_days.days.from_now
  end

  def reset_password
    #generate a random code
    code = [*"A".."Z", *"0".."9"].sample(6).join
    self.reset_password_token = code
    self.reset_password_send_at = Time.now
    peroid = BxgConfig.user.reset_password_expire_secondes
    self.reset_password_expire_at = self.reset_password_send_at.since(peroid)

    UserMailer.send_identify_code(self.email, code).deliver_now if self.save
  end
end

class BodyCondition
  include Mongoid::Document
  embedded_in :user
  #include height, weight, and tags
  field :height, type: Integer
  field :weight, type: Integer
  field :tags,   type: Array

  validates_numericality_of :height, greater_than: 0, less_than: 300
  validates_numericality_of :weight, greater_than: 0, less_than: 500
  validate :body_condition_format

  #avoid to create object_id field
  def identify    
  end

  private
  def body_condition_format
    self.errors.add(:tags, 'body condition tags count at most 2') if tags.count > 2
    tags.each do |tag|
      self.errors.add(:tags, 'tag is too long, max length is 20') if tag && tag.length > 20
    end
  end
end
