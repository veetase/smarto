FactoryGirl.define do
  factory :splash do
    name "Happy New Year"
    description "lallaal"
    url "http://www.baidu.com"
    picture { fixture_file_upload(Rails.root.join('images', 'dou.jpg'), 'image/jpg') }
  end

end
