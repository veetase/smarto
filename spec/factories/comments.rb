FactoryGirl.define do
  factory :comment do
    content "test content"
    association :commentable, factory: :spot
    user
  end
end
