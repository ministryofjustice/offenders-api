require 'rails_helper'

RSpec.describe Offender, type: :model do
  subject { create(:offender, noms_id: 'A123BC') }

  it { is_expected.to have_many(:identities) }
  it { is_expected.to belong_to(:current_identity) }

  it { is_expected.to validate_presence_of(:noms_id) }

  let!(:offender_1) do
    create(:offender, noms_id: 'A1234BC')
  end

  let!(:offender_2) do
    create(:offender, noms_id: 'A9876ZX')
  end

  let!(:offender_3) do
    create(:offender, noms_id: 'A4567FG', merged_to_id: offender_1.id)
  end

  let!(:identity_1) do
    create(:identity, offender: offender_1, status: 'active')
  end

  let!(:identity_2) do
    create(:identity, offender: offender_2)
  end

  let!(:identity_3) do
    create(:identity, offender: offender_3)
  end

  before do
    offender_1.update_attribute :current_identity, identity_1
    offender_2.update_attribute :current_identity, identity_2
    offender_3.update_attribute :current_identity, identity_3
  end

  describe 'validates uniqueness of noms_id' do
    context 'when another record with same noms_id is unmerged' do
      before { offender_1.noms_id = offender_2.noms_id }

      it 'is invalid' do
        expect(offender_1).to_not be_valid
      end
    end

    context 'when another record with same noms_id has been merged' do
      before { offender_1.noms_id = offender_3.noms_id }

      it 'is valid' do
        expect(offender_1).to be_valid
      end
    end
  end

  describe 'scopes' do
    context 'active' do
      it 'scopes active offenders' do
        expect(Offender.active.count).to be 1
        expect(Offender.active.first).to eq offender_1
      end
    end

    context 'inactive' do
      it 'scopes active offenders' do
        expect(Offender.inactive.count).to be 1
        expect(Offender.inactive.first).to eq offender_2
      end
    end

    context 'not_merged' do
      it 'scopes not merged offenders' do
        expect(Offender.not_merged.count).to be 2
        expect(Offender.not_merged).to include(offender_1, offender_2)
      end
    end
  end

  describe '.search' do
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

  describe '#merged?' do
    context 'when merged' do
      it 'returns true' do
        expect(offender_3.merged?).to be true
      end
    end

    context 'when not merged' do
      it 'returns false' do
        expect(offender_1.merged?).to be false
      end
    end
  end
end
