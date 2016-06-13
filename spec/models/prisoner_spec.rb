require 'rails_helper'

RSpec.describe Prisoner, type: :model do
  it { is_expected.to have_many(:aliases).with_foreign_key(:prisoner_id) }
end
