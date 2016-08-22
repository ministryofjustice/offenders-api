require 'rails_helper'

RSpec.describe ParseCsv do
  let(:csv_data) { fixture_file_upload('files/prisoners.csv', 'text/csv') }

  describe '#call' do
    context 'when parsing prisoners' do
      before do
        create(:prisoner)
        described_class.call(csv_data)
      end

      it 'creates prisoner records' do
        expect(Prisoner.count).to eq(2)
      end

      it 'imports all the fields correctly' do
        prisoner_A1234BC = Prisoner.find_by!(noms_id: 'A1234BC')

        expect(prisoner_A1234BC.given_name).to eq('BOB')
        expect(prisoner_A1234BC.middle_names).to eq('ROBERT')
        expect(prisoner_A1234BC.surname).to eq('DYLAN')
        expect(prisoner_A1234BC.title).to eq('MR')
        expect(prisoner_A1234BC.date_of_birth).to eq(Date.civil(1941, 5, 24))
        expect(prisoner_A1234BC.gender).to eq('M')
        expect(prisoner_A1234BC.pnc_number).to eq('05/123456A')
        expect(prisoner_A1234BC.nationality_code).to eq('BRIT')
        expect(prisoner_A1234BC.cro_number).to eq('123456/01A')
      end

      it 'empties temporary table' do
        expect(TemporaryPrisoner.count).to be_zero
      end
    end

    context 'when parsing aliases' do
      let(:csv_data) { fixture_file_upload('files/aliases.csv', 'text/csv') }

      before do
        create(:prisoner, noms_id: 'A1234BC')
        create(:alias)
        described_class.call(csv_data)
      end

      it 'creates aliases records' do
        expect(Prisoner.find_by!(noms_id: 'A1234BC').aliases.count).to eq(2)
      end

      it 'imports all the fields correctly' do
        first_alias = Prisoner.find_by!(noms_id: 'A1234BC').aliases.first

        expect(first_alias.given_name).to eq('JOHN')
        expect(first_alias.surname).to eq('WHITE')
        expect(first_alias.gender).to eq('Male')
        expect(first_alias.date_of_birth).to eq(Date.civil(1991, 7, 17))
      end

      it 'empties temporary table' do
        expect(TemporaryAlias.count).to be_zero
      end
    end

    context 'invalid CSV data' do
      context 'with invalid headers' do
        let(:csv_data) { fixture_file_upload('files/prisoners_with_invalid_headers.csv', 'text/csv') }

        it 'throws a MalformedHeaderError' do
          expect{described_class.call(csv_data)}.
            to raise_error(ParseCsv::MalformedHeaderError)
        end
      end

      context 'with invalid records' do
        let(:csv_data) { fixture_file_upload('files/prisoners_with_invalid_content.csv', 'text/csv') }

        it 'throws an error with the line number' do
          expect{described_class.call(csv_data)}.
            to raise_error(ParseCsv::ParsingError)
        end
      end
    end
  end
end
