FactoryGirl.define do
  factory :product do
    title { Faker::Name.name }
    description "MyText"
    price { rand() * 100 }
    published false
    quantity 5
  end
end
