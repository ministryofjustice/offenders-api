require 'rails_helper'

RSpec.describe ImportPrisoners do
  let(:prisoners) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
  let(:aliases) { fixture_file_upload('files/aliases.csv', 'text/csv') }

  let(:params) { { file: prisoners } }

  subject { ImportPrisoners.new(params) }

  describe '#call' do
    context 'when valid creates an import' do
      it 'creates an Import record' do
        subject.call
        expect(Import.count).to eq(1)
        expect(Import.first).to eq(subject.import)
      end
    end

    context 'when invalid doesn not create an import' do
      it 'does not create an Import record' do
        subject.params.delete(:file)
        subject.call
        expect(Import.count).to eq(0)
        expect(Import.first).to eq(nil)
      end
    end
  end

  describe '#import' do
    context 'before #call triggered' do
      it 'returns nil' do
        expect(subject.import).to eq(nil)
      end
    end

    context 'after #call triggered' do
      it 'returns the import object' do
        subject.call
        expect(subject.import).to be_a(Import)
      end
    end
  end

  describe '#success?' do
    context 'when invalid' do
      it 'returns false' do
        subject.params.delete(:file)
        subject.call
        expect(subject.success?).to be(false)
      end
    end

    context 'when valid' do
      it 'returns true' do
        subject.call
        expect(subject.success?).to be(true)
      end
    end
  end

  describe '#errors' do
    it 'returns errors' do
      expect(subject.errors).to eq([])
    end
  end

  describe '#process_import_file' do
    context 'when importing prisoners' do
      let(:params) { { file: prisoners } }

      before { subject.call }

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
      let(:params) { { file: aliases } }

      before do
        create(:prisoner, noms_id: 'A1234BC')
        subject.call
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
