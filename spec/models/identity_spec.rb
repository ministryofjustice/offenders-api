require 'rails_helper'

RSpec.describe Identity, type: :model do
  it { is_expected.to belong_to(:offender) }

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
      create(:identity, offender: offender_1, status: 'active')
    end

    let!(:identity_2) do
      create(:identity, offender: offender_2)
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
  end

  describe '.search' do
    let!(:offender_1) do
      create(:offender, noms_id: 'A1234BC', establishment_code: 'LEI')
    end

    let!(:offender_2) do
      create(:offender, noms_id: 'A9876ZX', establishment_code: 'BMI')
    end

    let!(:identity_1) do
      create(:identity, offender: offender_1,
                        given_name: 'ALANIS', middle_names: 'LENA ROBERTA', surname: 'BROWN',
                        gender: 'M', date_of_birth: '19650807', pnc_number: '74/832963V', cro_number: '195942/38G')
    end

    let!(:identity_2) do
      create(:identity, offender: offender_1,
                        given_name: 'DEBBY', middle_names: 'LAURA MARTA', surname: 'YELLOW',
                        gender: 'M', date_of_birth: '19691128', pnc_number: '99/135626A', cro_number: '639816/39Y')
    end

    let!(:identity_3) do
      create(:identity, offender: offender_2,
                        given_name: 'JONAS', middle_names: 'JULIUS', surname: 'CEASAR',
                        gender: 'F', date_of_birth: '19541009', pnc_number: '38/836893N', cro_number: '741860/84F')
    end

    context 'name search' do
      context 'when query matches' do
        let(:params) { { given_name: 'ala', surname: 'brown' } }

        it 'returns matching records' do
          expect(Identity.search(params)).to eq [identity_1]
        end
      end

      context 'when query does not match' do
        let(:params) { { given_name: 'luke' } }

        it 'returns an empty array' do
          expect(Identity.search(params)).to eq []
        end
      end
    end

    context 'noms_id search' do
      context 'when query matches' do
        let(:params) { { noms_id: 'A1234BC' } }

        it 'returns matching records' do
          expect(Identity.search(params)).to eq [identity_1, identity_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { noms_id: 'X1234FG' } }

        it 'returns an empty array' do
          expect(Identity.search(params)).to eq []
        end
      end
    end

    context 'date_of_birth search' do
      context 'when query matches' do
        let(:params) { { date_of_birth: '19691128' } }

        it 'returns matching records' do
          expect(Identity.search(params)).to eq [identity_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { date_of_birth: '19710309' } }

        it 'returns an empty array' do
          expect(Identity.search(params)).to eq []
        end
      end
    end

    context 'date_of_birth in range search' do
      context 'when query matches' do
        let(:params) { { date_of_birth_from: '19680101', date_of_birth_to: '19700101' } }

        it 'returns matching records' do
          expect(Identity.search(params)).to eq [identity_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { date_of_birth_from: '19720101', date_of_birth_to: '19740101' } }

        it 'returns an empty array' do
          expect(Identity.search(params)).to eq []
        end
      end
    end

    context 'pnc_number search' do
      context 'when query matches' do
        let(:params) { { pnc_number: '38/836893N' } }

        it 'returns matching records' do
          expect(Identity.search(params)).to eq [identity_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { pnc_number: '76/127718Z' } }

        it 'returns an empty array' do
          expect(Identity.search(params)).to eq []
        end
      end
    end

    context 'cro_number search' do
      context 'when query matches' do
        let(:params) { { cro_number: '195942/38G' } }

        it 'returns matching records' do
          expect(Identity.search(params)).to eq [identity_1]
        end
      end

      context 'when query does not match' do
        let(:params) { { cro_number: '319618/23G' } }

        it 'returns an empty array' do
          expect(Identity.search(params)).to eq []
        end
      end
    end

    context 'establishment_code search' do
      context 'when query matches' do
        let(:params) { { establishment_code: 'BMI' } }

        it 'returns matching records' do
          expect(Identity.search(params)).to eq [identity_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { establishment_code: 'BXI' } }

        it 'returns an empty array' do
          expect(Identity.search(params)).to eq []
        end
      end
    end

    context 'gender search' do
      context 'when query matches' do
        let(:params) { { gender: 'M' } }

        it 'returns matching records' do
          expect(Identity.search(params)).to eq [identity_1, identity_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { gender: 'NS' } }

        it 'returns an empty array' do
          expect(Identity.search(params)).to eq []
        end
      end
    end

    context 'multiple fields search' do
      context 'when query matches' do
        let(:params) do
          {
            given_name: 'jon',
            surname: 'ceasar',
            noms_id: 'A9876ZX',
            date_of_birth: '19541009',
            gender: 'F',
            establishment_code: 'BMI',
            pnc_number: '38/836893N',
            cro_number: '741860/84F'
          }
        end

        it 'returns matching records' do
          expect(Identity.search(params)).to eq [identity_3]
        end
      end

      context 'when query does not match' do
        let(:params) do
          {
            given_name: 'jan',
            middle_names: 'rob',
            noms_id: 'A8765IO',
            date_of_birth: '19720911',
            gender: 'M',
            establishment_code: 'LEI',
            pnc_number: '38/525271A',
            cro_number: '056339/17X'
          }
        end

        it 'returns an empty array' do
          expect(Identity.search(params)).to eq []
        end
      end
    end

    context 'ordering' do
      it 'orders record by surname, given_name, middle_names' do
        expect(Identity.search({})).to eq [identity_1, identity_3, identity_2]
      end
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
end
