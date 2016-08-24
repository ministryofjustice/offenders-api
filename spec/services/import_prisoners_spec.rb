require 'rails_helper'

RSpec.describe ImportPrisoners do
  let(:prisoners) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
  let(:aliases) { fixture_file_upload('files/aliases.csv', 'text/csv') }

  let(:import) { Import.create(file: prisoners) }

  describe '#call' do
    context 'when successful' do
      it 'calls the parse csv service with the data' do
        expect(ParseCsv).to receive(:call).with(import.file.read)
        ImportPrisoners.call(import.file.read, import)
      end

      it 'marks the import successful' do
        ImportPrisoners.call(import.file.read, import)
        expect(import.status).to eq('successful')
      end

      it 'removes all other imports' do
        Import.create(file: aliases)
        ImportPrisoners.call(import.file.read, import)
        expect(Import.count).to be 1
      end
    end

    context 'when failing' do
      before do
        expect(ParseCsv).to receive(:call).and_raise(Exception)
      end

      it 'marks the import failed' do
        ImportPrisoners.call(import.file.read, import)
        expect(import.status).to eq('failed')
      end

      it 'sends an email' do
        expect {
          ImportPrisoners.call(import.file.read, import)
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
end
