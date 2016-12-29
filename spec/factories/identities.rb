FactoryGirl.define do
  factory :identity, class: Identity do
    offender

    given_name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(80.years.ago, 20.years.ago) }
    gender { %w(M F).sample }
    pnc_number { rand(9999) }
    cro_number { rand(9999) }

    trait :active do
      status 'active'
    end
  end
end
