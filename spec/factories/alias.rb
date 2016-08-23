FactoryGirl.define do
  factory :alias, class: Alias do
    prisoner
    given_name 'John'
    surname 'Smith'
    date_of_birth '19781010'.to_date
    gender 'M'
  end
end
