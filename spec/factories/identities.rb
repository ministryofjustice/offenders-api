FactoryGirl.define do
  factory :identity, class: Identity do
    offender

    title { %w(MR MRS MISS MS DR SIR LADY LORD).sample }
    given_name { Faker::Name.first_name.upcase }
    middle_names { Faker::Name.first_name.upcase }
    surname { Faker::Name.last_name.upcase }
    suffix { %w(JR SR).sample }
    date_of_birth { Faker::Date.between(80.years.ago, 20.years.ago) }
    gender { %w(M F).sample }
    pnc_number { rand(999_999) }
    cro_number { rand(999_999) }
    ethnicity_code { %w(A1 B1 W1 W3).sample }

    trait :active do
      status 'active'
    end
  end
end
