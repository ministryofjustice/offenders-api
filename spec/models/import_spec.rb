require 'rails_helper'

RSpec.describe Import, type: :model do
  it { should validate_presence_of(:file) }
  it { should validate_presence_of(:md5) }
  it { should validate_uniqueness_of(:md5) }

  describe 'md5' do
    subject { Import.new(file: fixture_file_upload('files/sample_import.csv', 'text/csv')) }

    before { subject.save! }

    it 'should generate and save an md5 hash when creating an import' do
      expect(Import.count).to eq(1)
      expect(Import.first.md5).to_not be_blank
    end

    it 'should not save when same file used to create another import' do
      import = Import.create(file: fixture_file_upload('files/sample_import.csv', 'text/csv'))
      expect(Import.count).to eq(1)
      expect(import.errors.messages).to include(md5: ['has already been taken'])
    end
  end
end
