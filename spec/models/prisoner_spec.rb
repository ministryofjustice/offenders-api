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

    let!(:prisoner_3) do
      create(:prisoner, noms_id: 'AC123', date_of_birth: Date.parse('19650201'))
    end

    context 'params not present' do
      it 'returns an empty set' do
        expect(Prisoner.search(params)).to eq([])
      end
    end

    context 'params present' do
      context 'no matching records exist' do
        let(:params) do
          [
            { noms_id: 'CC123', date_of_birth: Date.parse('19750201') }
          ]
        end

        it 'returns matching records' do
          expect(Prisoner.search(params)).to match_array([])
        end
      end

      context 'searching for multiple records' do
        let(:params) do
          [
            { noms_id: 'AA123', date_of_birth: Date.parse('19750201') },
            { noms_id: 'AC123', date_of_birth: Date.parse('19650201') },
            { noms_id: 'AZ123', date_of_birth: Date.parse('19650201') }
          ]
        end

        it 'returns matching records' do
          expect(Prisoner.search(params)).to match_array([prisoner_1, prisoner_3])
        end
      end

      context 'searching for single record' do
        let(:params) do
          [
            { noms_id: 'AC123', date_of_birth: Date.parse('19650201') }
          ]
        end

        it 'returns matching record' do
          expect(Prisoner.search(params)).to match_array([prisoner_3])
        end
      end
    end
  end
end
