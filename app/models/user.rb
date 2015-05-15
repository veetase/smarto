require 'uti/uc_sms'
class User < ActiveRecord::Base
  has_many :spots
  before_create :generate_authentication_token!
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :trackable

  module Gender
    UNDEFINED = 0
    MALE      = 1
    FEMALE    = 2
  end

  #Validates
  validates_presence_of    :password, :on=>:create
  validates_length_of    :password, :within => Devise.password_length, :allow_blank => true
  validates :auth_token, :phone, uniqueness: true
  validates :password, length: { is: 4}
  validates :phone, format: { with: /\A1[3, 5, 8]\d{9}\z/i}
  validates :nick_name, length: { maximum: 20 }
  validates :avatar, length: { maximum: 100 }
  validates :gender, inclusion: { in: [Gender::UNDEFINED, Gender::MALE, Gender::FEMALE]}, :allow_nil => true
  validates :figure, numericality: { greater_than: -10, less_than: 50} #The heaviest man ever lived in the world is 635
  validates :age, numericality: { greater_than: 0, less_than: 130} #The heaviest man ever lived in the world is 635
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
    code = random_code
    self.reset_password_token = code
    self.reset_password_sent_at = Time.now
    peroid = BxgConfig.user.reset_password_expire_secondes
    self.reset_password_expire_at = self.reset_password_sent_at.since(peroid)
    sms = UcSms.new
    sms.delay.send_sms(sms.reset_password_sms(user.phone, code))
    #UserMailer.send_identify_code(self.email, code).deliver_later if self.save
  end

  def change_phone
    code = random_code
    self.confirmation_token = code
    self.confirmation_sent_at = Time.now
    peroid = BxgConfig.user.confirmation_expire_secondes
    self.confirmation_expire_at = self.confirmation_sent_at.since(peroid)
    sms = UcSms.new
    sms.delay.send_sms(sms.reset_password_sms(user.phone, code))
  end

  def valid_confirm_token?(token)
    self.confirmation_token == token && Time.now < self.confirmation_expire_at
  end

  def json_show_to_others
    self.as_json(only: [:avatar, :nick_name, :gender, :weight, :height, :tags])
  end

  def json_show_to_self
    self.as_json(only: [:id, :auth_token, :auth_token_expire_at, :phone, :nick_name, :gender, :avatar, :height, :weight, :tags])
  end

  private
  def validate_tags
    return true if tags.nil?
    if !tags.is_a?(Array) || tags.size > 10 || tags.detect{|t| t.size > 10}
      errors.add(:tags, :invalid)
    end
  end

  def random_code
    code = [*"A".."Z", *"0".."9"].sample(4).join
  end
end
