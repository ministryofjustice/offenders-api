require 'rails_helper'

RSpec.describe MergeOffenders do
  let!(:offender_1) do
    create(:offender, noms_id: 'A1234BC')
  end

  let!(:offender_2) do
    create(:offender, noms_id: 'A9876ZX')
  end

  let!(:identity_1) do
    create(:identity, offender: offender_1, status: 'active')
  end

  let!(:identity_2) do
    create(:identity, offender: offender_1, status: 'active')
  end

  let!(:identity_3) do
    create(:identity, offender: offender_1, status: 'active')
  end

  let!(:identity_4) do
    create(:identity, offender: offender_2, status: 'inactive')
  end

  let!(:identity_5) do
    create(:identity, offender: offender_2, status: 'active')
  end

  let(:params) do
    {
      identity_ids: [identity_1.id, identity_2.id, identity_5.id].join(','),
      current_identity_id: identity_2.id
    }
  end

  describe '#call' do
    before { described_class.call(offender_1, offender_2, params) }

    context 'setting identities' do
      it 'sets the passed identity ids to the offender' do
        expect(offender_2.reload.identities.active.pluck(:id).sort)
          .to eq [identity_1.id, identity_2.id, identity_5.id].sort
      end

      it 'soft deletes the extraneous identities' do
        expect(identity_3.reload.status).to eq 'deleted'
        expect(identity_4.reload.status).to eq 'deleted'
      end
    end

    it 'sets the current_identity of the offender' do
      expect(offender_2.reload.current_identity).to eq identity_2
    end

    it 'sets the merged_to_id of the other offender' do
      expect(offender_1.reload.merged_to_id).to eq offender_2.id
    end
  end
end
