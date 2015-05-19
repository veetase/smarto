FactoryGirl.define do
  factory :spot do
    perception_tags ["Nice day", "windy", "Hot", "Cold"]
    comment "test comment"
    avg_temperature {Faker::Number.number(2)}
    mid_temperature {Faker::Number.number(2)}
    max_temperature {Faker::Number.number(2)}
    min_temperature {Faker::Number.number(2)}
    start_measure_time {Faker::Time.between(1.days.ago, Time.now)}
    measure_duration {(rand * 600).to_i}
    image {Faker::Avatar.image}
    image_shaped {Faker::Avatar.image}
    is_public true
    perception_value 0
    location "POINT(#{Faker::Address.longitude.to_f} #{Faker::Address.latitude.to_f})"
    category 1
    user
  end
end
