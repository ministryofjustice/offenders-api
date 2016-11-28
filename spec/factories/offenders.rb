FactoryGirl.define do
  factory :offender, class: Offender do
    sequence(:noms_id) { |n| "A123#{n}AA" }
  end
end
