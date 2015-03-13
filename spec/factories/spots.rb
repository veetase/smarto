FactoryGirl.define do
  factory :spot do
    location {{type: "Point", coordinates: [Faker::Address.longitude.to_f, Faker::Address.latitude.to_f] }}
    perception {{tags: ["Nice day", "windy", "Hot", "Cold"], comment: "good for walk"}}
    picture {{crude: Faker::Avatar.image, shaped: Faker::Avatar.image}}
    env_info {{temperature: 20}}
    user
  end
end
