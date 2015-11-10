require 'uti/uc_sms'
class UcSmsJob
  include Sidekiq::Worker
  def perform(phone_number, code, type="reset_password", expire_seconds=nil)
    sms = UcSms.new
    case type
    when "reset_password"
      sms.send_sms(sms.reset_password_sms(phone_number, code))
    when "register"
      sms.send_sms(sms.register_sms(phone_number, code, expire_seconds))
    end
  end
end
