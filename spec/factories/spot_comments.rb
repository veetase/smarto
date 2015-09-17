FactoryGirl.define do
  factory :spot_comment do
    content "test content"
    spot
    user
  end
end
