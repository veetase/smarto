require 'uti/uc_sms'
class User < ActiveRecord::Base
  self.sequence_name = "dou_id_seq"
  before_create :next_seq
  has_many :spots
  before_create :generate_authentication_token!
  devise :database_authenticatable, :async,
         :recoverable, :trackable, :rememberable

  module Gender
    UNDEFINED = 0
    MALE      = 1
    FEMALE    = 2
  end

  ROLES = %i[admin QA]


  #Validates
  validates_presence_of    :password, :on=>:create
  validates :auth_token, :phone, uniqueness: true
  validates :password, length: { is: 4}, :on=>:create
  validates :phone, format: { with: /\A1[3, 5, 7, 8]\d{9}\z/i}
  validates :nick_name, length: { maximum: 20 }
  validates :avatar, length: { maximum: 100 }
  validates :gender, inclusion: { in: [Gender::UNDEFINED, Gender::MALE, Gender::FEMALE]}, :allow_nil => true
  validates :figure, numericality: { greater_than: -10, less_than: 50}, :allow_nil => true #The heaviest man ever lived in the world is 635
  validates :age, numericality: { greater_than: 0, less_than: 130}, :allow_nil => true #The heaviest man ever lived in the world is 635
  validate :validate_tags

  def roles=(roles)
    roles = [*roles].map { |r| r.to_sym }
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def has_role?(role)
    roles.include?(role)
  end

  def display_name
    self.nick_name || "No name"
  end

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
    UcSmsJob.perform_async(self.phone, code)
    self.save
    #UserMailer.send_identify_code(self.email, code).deliver_later if self.save
  end

  def change_phone
    code = random_code
    self.confirmation_token = code
    self.confirmation_sent_at = Time.now
    peroid = BxgConfig.user.confirmation_expire_secondes
    self.confirmation_expire_at = self.confirmation_sent_at.since(peroid)
    UcSmsJob.perform_async(self.phone, code)
    self.save
  end

  def valid_confirm_token?(token)
    self.confirmation_token == token && Time.now < self.confirmation_expire_at
  end

  def json_show_to_others
    self.as_json(only: [:avatar, :nick_name, :gender, :tags])
  end

  def json_show_to_self
    self.as_json(only: [:id, :auth_token, :auth_token_expire_at, :phone, :nick_name, :gender, :avatar, :figure, :tags])
  end

  def self.valid_phone_format
    /\A1[3, 5, 7, 8]\d{9}\z/i
  end

  private
  def validate_tags
    return true if tags.nil?
    if !tags.is_a?(Array) || tags.size > 10 || tags.detect{|t| t.size > 10}
      errors.add(:tags, :invalid)
    end
  end

  def random_code
    code = [*"0".."9"].sample(4).join
  end

  def next_seq
    result = User.connection.execute("SELECT nextval('dou_id_seq')")
    self.id = result[0]['nextval']
  end
end
