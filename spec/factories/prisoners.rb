FactoryGirl.define do
  factory :prisoner, class: Prisoner do
    given_name 'John'
    surname 'Smith'
    offender_id '1'
    noms_id 'A1234AA'
    date_of_birth '19781010'.to_date
  end
end
