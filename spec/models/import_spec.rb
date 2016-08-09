require 'rails_helper'

RSpec.describe Import, type: :model do
  it { is_expected.to validate_presence_of(:file) }

  let(:prisoners) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
  let(:aliases) { fixture_file_upload('files/aliases.csv', 'text/csv') }

  describe 'creating a new import' do
    subject { Import.new(file: prisoners) }

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
      let!(:import) { Import.create(file: prisoners) }

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
