FactoryGirl.define do
  factory :address do
    name { Faker::Name.name }
    city "Beijing"
    district "Chaoyang"
    detail "Tian an men NO.1"
    user
  end

end
