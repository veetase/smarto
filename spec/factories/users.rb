Faker::Config.locale = 'zh-CN'
FactoryGirl.define do
  factory :user do
    phone {random_phone}
    password "1234"
    gender 1
    figure 5
    age 18
    tags ["kind", "handsome"]
  end
end
def random_phone
  "18#{[*'0'..'9'].sample(9).join}"
end
