class UserMailer < ActionMailer::Base
  default from: "wangguangxing@bixuange.com"

  def send_email(comment)
    @comment = comment
    @url = 'http://bixuange.com'
    mail to: '503023009@qq.com' , subject: 'Welcome'
  end
  
  def self.broadcast(comment)
    users = Subscriber.all
    puts users
    users.each{ |user| UserMailer.send_email(comment).deliver_now}
  end

  def send_identify_code(email, code)
    @code = code
    mail(to: email, subject: I18n.t('mail.reset_password'))
  end
end
