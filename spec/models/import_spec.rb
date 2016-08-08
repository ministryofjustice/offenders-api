require 'rails_helper'

RSpec.describe Import, type: :model do
  it { is_expected.to validate_presence_of(:file) }

  let(:sample_import_1) { fixture_file_upload('files/sample_import_1.csv', 'text/csv') }
  let(:sample_import_2) { fixture_file_upload('files/sample_import_2.csv', 'text/csv') }

  describe 'creating a new import' do
    subject { Import.new(file: sample_import_1) }

    before { subject.save! }

    context 'when valid' do
      it 'should save the Import' do
        expect(Import.count).to be 1
      end

      it 'should create an upload record with an MD5 hash' do
        expect(Upload.count).to be 1
        expect(Upload.first.md5).to_not be_blank
      end
    end

    context 'when invalid (trying to import a previously used file)' do
      let!(:import) { Import.create(file: sample_import_1) }

      it 'should not create an import record' do
        expect(Import.count).to be 1
      end

      it 'should not create an upload record' do
        expect(Upload.count).to be 1
      end

      it 'should have a validation error' do
        expect(import.errors.messages).to include(base: ['File has already been uploaded'])
      end
    end
  end
end
