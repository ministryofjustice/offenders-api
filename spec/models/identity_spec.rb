require 'rails_helper'

RSpec.describe Identity, type: :model do
  it { is_expected.to belong_to(:offender) }

  it { is_expected.to validate_presence_of(:given_name) }
  it { is_expected.to validate_presence_of(:surname) }
  it { is_expected.to validate_presence_of(:date_of_birth) }
  it { is_expected.to validate_presence_of(:gender) }
end
