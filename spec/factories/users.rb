FactoryGirl.define do
  factory :user, class: User do
    email 'example@example.com'
    password 'password'
    password_confirmation 'password'

    trait :admin do
      role 'admin'
    end

    trait :staff do
      role 'staff'
    end
  end
end
