require 'rails_helper'

RSpec.describe Alias, type: :model do
  it { is_expected.to belong_to(:prisoner) }
end
