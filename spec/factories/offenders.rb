FactoryGirl.define do
  factory :offender, class: Offender do
    noms_id do
      l = Array.new(3) { ('A'..'Z').to_a.sample }
      n = Array.new(4) { (0..9).to_a.sample }
      [l[0], n[0], n[1], n[2], n[3], l[1], l[2]].join
    end
    nationality_code { %w(BRIT POL ITA).sample }
    establishment_code { %w(BRI LEI OUT).sample }
  end
end
