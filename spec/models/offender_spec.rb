require 'rails_helper'

RSpec.describe Offender, type: :model do
  subject { create(:offender, noms_id: 'A123BC') }

  it { is_expected.to have_many(:identities) }
  it { is_expected.to belong_to(:current_identity) }

  it { is_expected.to validate_presence_of(:noms_id) }
  it { is_expected.to validate_uniqueness_of(:noms_id) }

  describe '.search' do
    let!(:offender_1) do
      create(:offender, noms_id: 'A1234BC')
    end

    let!(:offender_2) do
      create(:offender, noms_id: 'A9876ZX')
    end

    let!(:identity_1) do
      create(:identity, offender: offender_1)
    end

    let!(:identity_2) do
      create(:identity, offender: offender_2)
    end

    context 'noms_id search' do
      context 'when query matches' do
        let(:params) { { noms_id: 'A9876ZX' } }

        it 'returns matching records' do
          expect(Offender.search(params)).to eq [offender_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { noms_id: 'X1234FG' } }

        it 'returns an empty array' do
          expect(Offender.search(params)).to eq []
        end
      end
    end
  end
end
