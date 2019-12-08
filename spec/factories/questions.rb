FactoryBot.define do
  factory :question do
    #sequence(:title) { |n| "title_#{n}" }
    #sequence(:body) { |n| "body_#{n}" }
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    factory :question_with_answer do
      after(:create) do |question|
        create(:answer, question: question)
      end
    end
  end
end
