FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "12345678"
    password_confirmation "12345678"
    gender 1
    height 170
    weight 60
    tags ["kind", "handsome"]    
  end

end
