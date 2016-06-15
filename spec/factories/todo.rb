FactoryGirl.define do
  factory :todo do
    title { Faker::Internet.name }
    body "body"
    status "Pending"
  end
end
