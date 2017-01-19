require 'rails_helper'

RSpec.describe Nickname, type: :model do
  it { is_expected.to belong_to(:nickname) }

  before { ParseNicknames.call(fixture_file_upload('files/nicknames.csv', 'text/csv')) }

  describe '.for' do
    it 'returns the correct nicknames' do
      expect(Nickname.for('ron').map(&:name)).to eq(%w(AARON ERIN RONNIE RON))
    end
  end
end
