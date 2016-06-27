require 'rails_helper'

RSpec.describe Prisoner, type: :model do
  it { should have_many(:aliases) }

  it { should validate_uniqueness_of(:offender_id) }
  it { should validate_uniqueness_of(:noms_id) }
  it { should validate_uniqueness_of(:pnc_number) }
end
