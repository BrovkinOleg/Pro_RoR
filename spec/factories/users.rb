FactoryBot.define do
  factory :user do
    email { 'user@test.com' }
    password { '12345678' }
  end
end
