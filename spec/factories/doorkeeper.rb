FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    sequence(:resource_owner_id) { |n| n }
    application
    expires_in 2.hours

    factory :clientless_access_token do
      application nil
    end
  end

  factory :application, class: Doorkeeper::Application do
    sequence(:name) { |n| "Application #{n}" }
    redirect_uri 'https://app.com/callback'

    trait :with_public_scope do
      scopes 'public'
    end

    trait :with_write_scope do
      scopes 'public write'
    end
  end
end
