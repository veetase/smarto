class UserMailer < ActionMailer::Base
  default from: "wuxiaaotongdemm@163.com"

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

end
