FactoryGirl.define do
  factory :station_spot do
    name "Tanglang"
    city "Shenzhen"
    location "POINT(#{Faker::Address.longitude.to_f} #{Faker::Address.latitude.to_f})"
    temperature {Faker::Number.number(2)}
    height {Faker::Number.number(2)}
  end

end
