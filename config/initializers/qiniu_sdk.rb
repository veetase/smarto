require 'qiniu'
Qiniu.establish_connection! :access_key => ENV['QINIU_ACCESS_TOKEN'], :secret_key => ENV['QINIU_SECRET_TOKEN']
