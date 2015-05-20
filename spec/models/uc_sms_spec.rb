require 'rails_helper'
require 'uti/uc_sms'
RSpec.describe UcSms, :type => :model do
  before { @sms = UcSms.new}
  subject { @sms }

  it { should respond_to(:send_sms) }
  it { should respond_to(:register_sms) }
  it { should respond_to(:reset_password_sms) }

  describe "create parts" do
    it "should return correct sig_parameter" do
      ret = @sms.send(:create_sig_parameter, Time.now)
      expect(ret.size).to eql 32
    end

    it "should return auth string" do
      ret = @sms.send(:create_auth_string, Time.now)
      expect(ret).not_to eql nil
    end

    it "should return correct http headers" do
      ret = @sms.send(:create_http_headers, "auth_string_for_test")
      expect(ret["Authorization"]).to eql "auth_string_for_test"
      expect(ret["Accept"]).to eql "application/json"
      expect(ret["Content-Type"]).to eql "application/json;charset=utf-8"
    end

    it "should create correct sign" do
      ret = @sms.send(:create_sign, "18867546758")
      expect(ret.size).to eql 32
    end
  end

  describe "request posting" do
    it "shouold successfully post sms massage" do
      ret = @sms.send_sms(@sms.reset_password_sms("18665351182", "1234"))
      expect(ret["respCode"]).to eql "000000"
      expect(ret["templateSMS"]["smsId"].size).to eql 32
      expect(ret["templateSMS"]["createDate"]).not_to eql nil
    end
  end

end
