require 'rails_helper'

RSpec.describe Prisoner, type: :model do
  it { should have_many(:aliases) }

  it { should validate_presence_of(:noms_id) }
  it { should validate_presence_of(:given_name) }
  it { should validate_presence_of(:surname) }
  it { should validate_presence_of(:date_of_birth) }
  it { should validate_presence_of(:gender) }
end
