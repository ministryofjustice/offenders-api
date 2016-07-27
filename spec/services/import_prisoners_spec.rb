require 'rails_helper'

RSpec.describe ImportPrisoners do
  let(:sample_import_1) { fixture_file_upload('files/sample_import_1.csv', 'text/csv') }
  let(:sample_import_2) { fixture_file_upload('files/sample_import_2.csv', 'text/csv') }

  let(:params) { { file: sample_import_1 } }

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
end
