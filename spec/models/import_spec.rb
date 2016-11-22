require 'rails_helper'

RSpec.describe Import, type: :model do
  it { is_expected.to validate_presence_of(:offenders_file) }
  it { is_expected.to validate_presence_of(:identities_file) }

  let(:offenders_file) { fixture_file_upload('files/offenders.csv', 'text/csv') }
  let(:identities_file) { fixture_file_upload('files/identities.csv', 'text/csv') }

  describe 'creating a new import' do
    subject { Import.new(offenders_file: offenders_file, identities_file: identities_file) }

    before { subject.save! }

    context 'when valid' do
      it 'saves the Import' do
        expect(Import.count).to be 1
      end

      it 'creates 2 upload records with the MD5 hash' do
        expect(Upload.count).to be 2
        expect(Upload.first.md5).to_not be_blank
        expect(Upload.last.md5).to_not be_blank
      end
    end

    context 'when invalid (trying to import a previously used file)' do
      let!(:import) { Import.create(offenders_file: offenders_file) }

      it 'does not create an import record' do
        expect(Import.count).to be 1
      end

      it 'does not create upload records' do
        expect(Upload.count).to be 2
      end

      it 'has a validation error' do
        expect(import.errors.messages).to include(base: ['Offenders file has already been uploaded'])
      end
    end
  end
end
