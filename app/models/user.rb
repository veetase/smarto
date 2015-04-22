class User < ActiveRecord::Base
  has_many :spots
  before_create :generate_authentication_token!
  devise :database_authenticatable, :async, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  module Gender
    UNDEFINED = 0
    MALE      = 1
    FEMALE    = 2
  end

  #Validates
  validates :auth_token, uniqueness: true
  validates :nick_name, length: { maximum: 20 }
  validates :avatar, length: { maximum: 100 }
  validates :gender, inclusion: { in: [Gender::UNDEFINED, Gender::MALE, Gender::FEMALE]}, :allow_nil => true
  validates :height, numericality: { greater_than: 0, less_than: 300}, :allow_nil => true #The tallest man ever lived in the world is 272
  validates :weight, numericality: { greater_than: 0, less_than: 700}, :allow_nil => true #The heaviest man ever lived in the world is 635
  validate :validate_tags
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
    self.reset_password_sent_at = Time.now
    peroid = BxgConfig.user.reset_password_expire_secondes
    self.reset_password_expire_at = self.reset_password_sent_at.since(peroid)

    UserMailer.send_identify_code(self.email, code).deliver_later if self.save
  end

  def json_show_to_others
    self.as_json(only: [:avatar, :nick_name, :gender, :weight, :height, :tags])
  end

  def json_show_to_self
    self.as_json(only: [:id, :auth_token, :auth_token_expire_at, :email, :nick_name, :gender, :avatar, :height, :weight, :tags])
  end

  private
  def validate_tags
    return true if tags.nil?
    if !tags.is_a?(Array) || tags.size > 10 || tags.detect{|t| t.size > 10}
      errors.add(:tags, :invalid)
    end
  end
end
