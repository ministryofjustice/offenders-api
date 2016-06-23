require 'rails_helper'

RSpec.describe Alias, type: :model do
  it { should belong_to(:prisoner) }
end
