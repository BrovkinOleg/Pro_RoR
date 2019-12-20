FactoryBot.define do
  factory :comment do
    body { "MyText" }
  end

  trait :invalid_comment do
    body { nil }
  end
end
