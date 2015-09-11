class UpdatePhoneNumberAttributionJob
  include Sidekiq::Worker
  def perform
    max_user_id = TelAttribution.maximum("user_id")

    if max_user_id
      left_users = User.where('id > ?', max_user_id).order('id')
    else
      left_users = User.all.order('id')
    end

    left_users.each do |u|
      response = HTTParty.get("http://life.tenpay.com/cgi-bin/mobile/MobileQueryAttribution.cgi?chgmobile=#{u.phone}")
      return unless response.message == "OK"

      begin
        tel_attr = u.create_tel_attribution(
          province: response.parsed_response["root"]["province"],
          city: response.parsed_response["root"]["city"],
          isp: response.parsed_response["root"]["supplier"]
        )
      rescue
        Rails.logger.info "tel attribution update failed!"
      end
    end
  end
end
