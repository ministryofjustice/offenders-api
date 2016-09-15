require 'rails_helper'

RSpec.describe Import, type: :model do
  it { is_expected.to validate_presence_of(:prisoners_file) }
  it { is_expected.to validate_presence_of(:aliases_file) }

  let(:prisoners_file) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
  let(:aliases_file) { fixture_file_upload('files/aliases.csv', 'text/csv') }

  describe 'creating a new import' do
    subject { Import.new(prisoners_file: prisoners_file, aliases_file: aliases_file) }

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
      let!(:import) { Import.create(prisoners_file: prisoners_file, aliases_file: aliases_file) }

      it 'does not create an import record' do
        expect(Import.count).to be 1
      end

      it 'does not create upload records' do
        expect(Upload.count).to be 2
      end

      it 'has a validation error' do
        expect(import.errors.messages).
          to include(base: ['Prisoners file has already been uploaded', 'Aliases file has already been uploaded'])
      end
    end
  end
end
