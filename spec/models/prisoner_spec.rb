require 'rails_helper'

RSpec.describe Prisoner, type: :model do
  it { is_expected.to have_many(:aliases) }

  it { is_expected.to validate_presence_of(:noms_id) }
  it { is_expected.to validate_presence_of(:given_name) }
  it { is_expected.to validate_presence_of(:surname) }
  it { is_expected.to validate_presence_of(:date_of_birth) }
  it { is_expected.to validate_presence_of(:gender) }

  describe '.search' do
    let(:params) do
      nil
    end

    let!(:prisoner_1) do
      create(:prisoner, noms_id: 'AA123', date_of_birth: Date.parse('19750201'))
    end

    let!(:prisoner_2) do
      create(:prisoner, noms_id: 'AB123', date_of_birth: Date.parse('19750201'))
    end

    context 'params not present' do
      it 'returns an empty set' do
        expect(Prisoner.search(params)).to eq([])
      end
    end

    context 'params present' do
      let(:params) do
        [
          { noms_id: 'AA123', date_of_birth: Date.parse('19750201') }
        ]
      end

      it 'returns matching records' do
        expect(Prisoner.search(params)).to eq([prisoner_1])
      end
    end
  end
end
