require 'rails_helper'

RSpec.describe Identity, type: :model do
  it { is_expected.to belong_to(:offender) }

  it { is_expected.to validate_presence_of(:offender) }
  it { is_expected.to validate_presence_of(:given_name) }
  it { is_expected.to validate_presence_of(:surname) }
  it { is_expected.to validate_presence_of(:date_of_birth) }
  it { is_expected.to validate_presence_of(:gender) }
  it { is_expected.to validate_inclusion_of(:status).in_array(%w(inactive active deleted)) }

  describe 'scopes' do
    let!(:offender_1) do
      create(:offender, noms_id: 'A1234BC')
    end

    let!(:offender_2) do
      create(:offender, noms_id: 'A9876ZX')
    end

    let!(:identity_1) do
      create(:identity, offender: offender_1, given_name: 'DEBORAH', status: 'active')
    end

    let!(:identity_2) do
      create(:identity, offender: offender_2, surname: 'SMITH')
    end

    context 'active' do
      it 'scopes active offenders' do
        expect(Identity.active.count).to be 1
        expect(Identity.active.first).to eq identity_1
      end
    end

    context 'inactive' do
      it 'scopes active offenders' do
        expect(Identity.inactive.count).to be 1
        expect(Identity.inactive.first).to eq identity_2
      end
    end

    context 'nicknames' do
      before { ParseNicknames.call(fixture_file_upload('files/nicknames.csv', 'text/csv')) }

      it 'scopes matching nicknames' do
        expect(Identity.nicknames('debby').count).to be 1
        expect(Identity.nicknames('debby').first).to eq identity_1
      end
    end

    context 'soundex' do
      it 'scopes matching surnames with same soundex' do
        expect(Identity.soundex('smidth').count).to be 1
        expect(Identity.soundex('smidth').first).to eq identity_2
      end
    end
  end

  describe '.search' do
    it 'initializes and invokes SearchIdentities service with params' do
      params = {}
      search_identities_double = instance_double(SearchIdentities)

      expect(SearchIdentities).to receive(:new).with(params).and_return(search_identities_double)
      expect(search_identities_double).to receive(:call)

      Identity.search(params)
    end
  end

  describe '#soft_delete!' do
    let(:identity) { create(:identity, status: 'active') }

    context 'success' do
      before { identity.soft_delete! }

      it 'sof deletes the identity' do
        expect(identity.status).to eq 'deleted'
      end
    end

    context 'failure' do
      before do
        allow(identity).to receive(:update_attribute).and_return(false)

        identity.soft_delete!
      end

      it 'does not soft delete the identity' do
        expect(identity.status).to eq 'active'
      end
    end
  end

  describe '#make_active!' do
    let(:identity) { create(:identity, status: 'inactive') }

    context 'success' do
      before { identity.make_active! }

      it 'activates the identity' do
        expect(identity.status).to eq 'active'
      end
    end

    context 'failure' do
      before do
        allow(identity).to receive(:update_attribute).and_return(false)

        identity.make_active!
      end

      it 'does not activate the identity' do
        expect(identity.status).to eq 'inactive'
      end
    end
  end

  describe '#current' do
    let!(:offender_1) do
      create(:offender, noms_id: 'A1234BC')
    end

    let!(:identity_1) do
      create(:identity, offender: offender_1)
    end

    let!(:identity_2) do
      create(:identity, offender: offender_1)
    end

    before { offender_1.update current_identity: identity_1 }

    context 'when is current identity of offender' do
      it 'returns true' do
        expect(identity_1.current).to be true
      end
    end

    context 'when is not current identity of offender' do
      it 'returns false' do
        expect(identity_2.current).to be false
      end
    end
  end
end
