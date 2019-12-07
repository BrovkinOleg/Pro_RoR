FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "text_#{n}"}

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end
  end
end
