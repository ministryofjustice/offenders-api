require 'rails_helper'

RSpec.describe Import, type: :model do
  it { should validate_presence_of(:file) }

  let(:sample_import_1) { fixture_file_upload('files/sample_import_1.csv', 'text/csv') }
  let(:sample_import_2) { fixture_file_upload('files/sample_import_2.csv', 'text/csv') }

  describe 'creating a new import' do
    subject { Import.new(file: sample_import_1) }

    before { subject.save! }

    it 'should create an Upload record saving the md5 hash when successful' do
      expect(Import.count).to eq(1)
      expect(Upload.count).to eq(1)
      expect(Upload.first.md5).to_not be_blank
    end

    it 'should not save when same file used to create another import' do
      import = Import.create(file: sample_import_1)
      expect(Import.count).to eq(1)
      expect(Upload.count).to eq(1)
      expect(import.errors.messages).to include(base: ['File has already been uploaded'])
    end
  end
end
