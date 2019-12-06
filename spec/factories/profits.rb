FactoryBot.define do
  factory :profit do
    sequence(:name) { |n| "name#{n}" }
  end
end
