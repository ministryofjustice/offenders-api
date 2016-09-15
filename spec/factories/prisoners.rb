FactoryGirl.define do
  factory :prisoner, class: Prisoner do
    sequence(:noms_id) { |n| "A123#{n}AA" }
    given_name 'John'
    surname 'Smith'
    date_of_birth '19781010'.to_date
    gender 'M'
  end
end
