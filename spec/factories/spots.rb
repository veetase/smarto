FactoryGirl.define do
  factory :spot do
    location [Faker::Address.latitude.to_i, Faker::Address.longitude.to_i]
    perception {{tags: ["Nice day", "windy", "Hot", "Cold"], comment: "good for walk"}}
    picture {{crude: Faker::Avatar.image, shaped: Faker::Avatar.image}}
    env_info {{temperature: 20}}
    user
  end
end
