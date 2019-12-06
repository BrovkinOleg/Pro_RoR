FactoryBot.define do
  sequence :name do |n|
    "MyLink_#{n}"
  end

  factory :link do
    name
    url { 'https://github.com/BrovkinOleg/' }
  end

  trait :invalid do
    url { 'invalid/link' }
  end

  trait :gist do
    url { 'https://gist.github.com/BrovkinOleg/938fe55889a5b407e827200d077809f4' }
  end
end
