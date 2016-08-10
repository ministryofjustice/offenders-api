require 'rails_helper'

RSpec.describe ImportPrisoners do
  let(:prisoners) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
  let(:aliases) { fixture_file_upload('files/aliases.csv', 'text/csv') }

  let(:params) { { file: prisoners } }

  subject { ImportPrisoners.new(params) }

  describe '#call' do
    context 'when valid' do
      it 'creates an Import record' do
        subject.call
        expect(Import.count).to eq(1)
        expect(Import.first).to eq(subject.import)
      end

      it 'calls the parse csv service with the file' do
        expect(ParseCsv).to receive(:call).with(File.read(params[:file]))
        subject.call
      end
    end

    context 'when invalid' do
      it 'does not create an Import record' do
        subject.params.delete(:file)
        subject.call
        expect(Import.count).to eq(0)
        expect(Import.first).to eq(nil)
      end

      it 'does not call the parse csv service' do
        expect(ParseCsv).to_not receive(:call)
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
