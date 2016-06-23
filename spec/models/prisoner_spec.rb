require 'rails_helper'

RSpec.describe Prisoner, type: :model do
  it { should have_many(:aliases) }
end
