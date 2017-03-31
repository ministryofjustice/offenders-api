FactoryGirl.define do
  factory :user, class: User do
    email 'example@example.com'
    role 'staff'

    trait :admin do
      role 'admin'
    end
  end
end
