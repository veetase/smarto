FactoryGirl.define do
  factory :order do
    pay_method 0
    association :user
    total 0
  end
end
