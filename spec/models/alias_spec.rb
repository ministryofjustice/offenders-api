require 'rails_helper'

RSpec.describe Alias, type: :model do
  it { should belong_to(:prisoner) }

  it { should validate_presence_of(:given_name) }
  it { should validate_presence_of(:surname) }
  it { should validate_presence_of(:date_of_birth) }
  it { should validate_presence_of(:gender) }
end
