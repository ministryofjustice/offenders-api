require 'rails_helper'

RSpec.describe Alias, type: :model do
  it { is_expected.to be_embedded_in(:prisoner) }
end
