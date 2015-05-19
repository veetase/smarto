require 'uti/uc_sms'
class UcSmsJob
  include Sidekiq::Worker
  def perform(phone_number, code)
    sms = UcSms.new
    sms.send_sms(sms.reset_password_sms(phone_number, code))
  end
end
