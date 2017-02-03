require 'rails_helper'

RSpec.describe ParseOffenders do
  let(:csv_data) { fixture_file_upload('files/data.csv', 'text/csv') }

  describe '#call' do
    context 'when parsing offenders' do
      context 'when offenders do not exist in local database' do
        before { described_class.call(csv_data) }

        it 'creates offender records' do
          expect(Offender.count).to eq(2)
        end

        it 'creates identities records' do
          expect(Identity.count).to eq(3)
        end

        it 'imports all the fields correctly for the offender' do
          offender = Offender.find_by!(noms_id: 'A1234BC')

          expect(offender.given_name).to eq('LARRY')
          expect(offender.middle_names).to eq('MARK, JOE')
          expect(offender.surname).to eq('LATITUDE')
          expect(offender.title).to eq('MR')
          expect(offender.date_of_birth).to eq(Date.civil(1970, 1, 30))
          expect(offender.gender).to eq('M')
          expect(offender.pnc_number).to eq('05/103329A')
          expect(offender.nationality_code).to eq('BRIT')
          expect(offender.cro_number).to eq('309129/05R')
          expect(offender.establishment_code).to eq('LEI')
          expect(offender.ethnicity_code).to eq('W1')
        end

        it 'imports all the fields correctly for the identity' do
          identity = Identity.find_by!(noms_offender_id: '1055829')

          expect(identity.noms_id).to eq('A1234BC')
          expect(identity.noms_offender_id).to eq('1055829')
          expect(identity.given_name).to eq('JOHN')
          expect(identity.middle_names).to eq('LUKE, FRANK')
          expect(identity.surname).to eq('DOE')
          expect(identity.title).to eq('MR')
          expect(identity.date_of_birth).to eq(Date.civil(1980, 2, 20))
          expect(identity.gender).to eq('M')
          expect(identity.pnc_number).to eq('07/3862805R')
          expect(identity.nationality_code).to eq('BRIT')
          expect(identity.cro_number).to eq('339223/02H')
          expect(identity.establishment_code).to eq('LEI')
          expect(identity.ethnicity_code).to eq('B1')
          expect(identity.status).to eq('active')
        end
      end

      context 'when offenders exist in local database' do
        before do
          offender_one = create(:offender, noms_id: 'A1234BC')
          offender_two = create(:offender, noms_id: 'A1234BU')
          create(:identity, offender: offender_one, noms_offender_id: '1056827')
          create(:identity, offender: offender_one, noms_offender_id: '1055829')
          create(:identity, offender: offender_two, noms_offender_id: '1055847')
          described_class.call(csv_data)
        end

        it 'does not create new offender records' do
          expect(Offender.count).to eq(2)
        end

        it 'does not create new identities records' do
          expect(Identity.count).to eq(3)
        end

        it 'updates all the fields correctly for the offender' do
          offender = Offender.find_by!(noms_id: 'A1234BC')

          expect(offender.given_name).to eq('LARRY')
          expect(offender.middle_names).to eq('MARK, JOE')
          expect(offender.surname).to eq('LATITUDE')
          expect(offender.title).to eq('MR')
          expect(offender.date_of_birth).to eq(Date.civil(1970, 1, 30))
          expect(offender.gender).to eq('M')
          expect(offender.pnc_number).to eq('05/103329A')
          expect(offender.nationality_code).to eq('BRIT')
          expect(offender.cro_number).to eq('309129/05R')
          expect(offender.establishment_code).to eq('LEI')
          expect(offender.ethnicity_code).to eq('W1')
        end

        it 'updates all the fields correctly for the identity' do
          identity = Identity.find_by!(noms_offender_id: '1055829')

          expect(identity.noms_id).to eq('A1234BC')
          expect(identity.noms_offender_id).to eq('1055829')
          expect(identity.given_name).to eq('JOHN')
          expect(identity.middle_names).to eq('LUKE, FRANK')
          expect(identity.surname).to eq('DOE')
          expect(identity.title).to eq('MR')
          expect(identity.date_of_birth).to eq(Date.civil(1980, 2, 20))
          expect(identity.gender).to eq('M')
          expect(identity.pnc_number).to eq('07/3862805R')
          expect(identity.nationality_code).to eq('BRIT')
          expect(identity.cro_number).to eq('339223/02H')
          expect(identity.establishment_code).to eq('LEI')
          expect(identity.ethnicity_code).to eq('B1')
        end
      end
    end

    context 'invalid CSV data' do
      context 'with invalid records' do
        let(:csv_data) { fixture_file_upload('files/invalid_data.csv', 'text/csv') }

        it 'throws an error with the line number' do
          expect { described_class.call(csv_data) }
            .to raise_error(ParseOffenders::ParsingError)
        end
      end
    end
  end
end
