require 'base64'
require 'uri'
require 'openssl'
class UcSms

  def initialize
    @base_url = BxgConfig.uc_sms.base_url
    @soft_version = BxgConfig.uc_sms.soft_version
    @account_sid = BxgConfig.uc_sms.account_sid
    @auth_token = ENV['SMS_AUTH_TOKEN']
    @smart_key = ENV['SMS_SMART_KEY']
    @app_id = BxgConfig.uc_sms.app_id
  end

  def send_sms(template)
    formatted_time = Time.now.to_formatted_s(:number)
    sig_parameter = create_sig_parameter(formatted_time)
    http_headers = create_http_headers(create_auth_string(formatted_time))
    query = template.call

    response = HTTParty.post("#{@base_url}/#{@soft_version}/Accounts/#{@account_sid}/Messages/templateSMS?sig=#{sig_parameter}",
      :body => query.to_json,
      :headers => http_headers
    )

    result = JSON.load response.body
    result['resp']
  end

  def register_sms(phone_number)
    register_sms = lambda do
      code = [*0..9].sample(4).join
      {templateSMS: {appId: @app_id, templateId: BxgConfig.uc_sms.register_tmplate_id, to: phone_number, param: code}}
    end
    register_sms
  end

  def reset_password_sms(phone_number, code)
    reset_password_sms = lambda do
      {templateSMS: {appId: @app_id, templateId: BxgConfig.uc_sms.reset_password_tmplate_id, to: phone_number, param: code}}
    end
    reset_password_sms
  end

  def create_sign(phone)
    sign_consist = "#{@account_sid}#{@app_id}#{phone}#{@smart_key}"
    sign = md5_hexdigest(sign_consist)
    sign
  end


  private
  def create_sig_parameter(time)
    sig_params_consist = "#{@account_sid}#{@auth_token}#{time}"
    md5_hexdigest(sig_params_consist).upcase
  end

  def create_auth_string(time)
    auth_string_consist = "#{@account_sid}:#{time}"
    Base64.strict_encode64(auth_string_consist)
  end

  def create_http_headers(auth_string)
    headers = { "Authorization"=> auth_string, "Accept"=> "application/json", "Content-Type" => "application/json;charset=utf-8" }
  end

  def md5_hexdigest(str)
    md5 = Digest::MD5.new
    md5 << str
    md5.hexdigest
  end
end
