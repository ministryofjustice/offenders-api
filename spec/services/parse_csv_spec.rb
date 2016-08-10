require 'rails_helper'

RSpec.describe ParseCsv do
  let(:prisoners) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
  let(:aliases) { fixture_file_upload('files/aliases.csv', 'text/csv') }

  describe '#call' do
    context 'when importing prisoners' do
      before { described_class.call(prisoners) }

      it 'creates prisoner records' do
        expect(Prisoner.count).to eq(2)
      end

      it 'imports all the fields correctly' do
        prisoner_A1234BC = Prisoner.where(noms_id: 'A1234BC').first

        expect(prisoner_A1234BC.given_name).to eq('BOB')
        expect(prisoner_A1234BC.middle_names).to eq('ROBERT')
        expect(prisoner_A1234BC.surname).to eq('DYLAN')
        expect(prisoner_A1234BC.title).to eq('MR')
        expect(prisoner_A1234BC.date_of_birth).to eq(Date.civil(1941, 5, 24))
        expect(prisoner_A1234BC.gender).to eq('M')
        expect(prisoner_A1234BC.pnc_number).to eq('05/123456A')
        expect(prisoner_A1234BC.nationality_code).to eq('BRIT')
        expect(prisoner_A1234BC.ethnicity_code).to eq('W3')
        expect(prisoner_A1234BC.sexual_orientation_code).to eq('HET')
        expect(prisoner_A1234BC.cro_number).to eq('123456/01A')
      end
    end

    context 'when importing aliases' do
      before do
        create(:prisoner, noms_id: 'A1234BC')
        described_class.call(aliases)
      end

      it 'creates aliases records' do
        expect(Prisoner.first.aliases.count).to eq(2)
      end

      it 'imports all the fields correctly' do
        first_alias = Prisoner.first.aliases.first

        expect(first_alias.given_name).to eq('JOHN')
        expect(first_alias.surname).to eq('WHITE')
        expect(first_alias.gender).to eq('Male')
        expect(first_alias.date_of_birth).to eq(Date.civil(1991, 7, 17))
      end
    end
  end
end
