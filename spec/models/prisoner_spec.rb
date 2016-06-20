require 'rails_helper'

RSpec.describe Prisoner, type: :model do
  it { is_expected.to embed_many(:aliases) }
end
