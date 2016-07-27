require 'rails_helper'

RSpec.describe Import, type: :model do
  it { should validate_presence_of(:file) }
  it { should validate_presence_of(:md5) }
  it { should validate_uniqueness_of(:md5) }

  let(:sample_import_1) { fixture_file_upload('files/sample_import_1.csv', 'text/csv') }
  let(:sample_import_2) { fixture_file_upload('files/sample_import_2.csv', 'text/csv') }

  describe 'md5' do
    subject { Import.new(file: sample_import_1) }

    before { subject.save! }

    it 'should generate and save an md5 hash when creating an import' do
      expect(Import.count).to eq(1)
      expect(Import.first.md5).to_not be_blank
    end

    it 'should not save when same file used to create another import' do
      import = Import.create(file: sample_import_1)
      expect(Import.count).to eq(1)
      expect(import.errors.messages).to include(md5: ['has already been taken'])
    end
  end

  describe 'remove previous imports' do
    subject { Import.new(file: sample_import_1) }

    before { subject.save! }

    it 'should remove previous imports when a new one is created' do
      expect(Import.count).to eq(1)
      import = Import.create(file: sample_import_2)
      expect(Import.count).to eq(1)
      expect(Import.first).to eq(import)
    end
  end
end
