require 'rails_helper'

RSpec.describe ParseNicknames do
  let(:csv_data) { fixture_file_upload('files/nicknames.csv', 'text/csv') }

  describe '#call' do
    before { described_class.call(csv_data) }

    it 'creates nickname records' do
      expect(Nickname.count).to eq(17)
    end

    it 'associates nicknames correctly' do
      aaron = Nickname.where(name: 'AARON').first
      ron = Nickname.where(name: 'RON').first
      expect(ron.nickname_id).to eq(aaron.id)
    end
  end
end
