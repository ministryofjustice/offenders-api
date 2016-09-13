require 'rails_helper'

RSpec.describe ImportPrisoners do
  let(:prisoners_file) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
  let(:aliases_file) { fixture_file_upload('files/aliases.csv', 'text/csv') }

  let(:import) { Import.create(prisoners_file: prisoners_file, aliases_file: aliases_file) }

  describe '#call' do
    context 'when successful' do
      it 'calls the parse csv service with the data' do
        expect(ParseCsv).to receive(:call).with(import.prisoners_file.read)
        expect(ParseCsv).to receive(:call).with(import.aliases_file.read)
        ImportPrisoners.call(import)
      end

      it 'marks the import successful' do
        ImportPrisoners.call(import)
        expect(import.status).to eq('successful')
      end

      it 'removes all other imports' do
        Import.create(prisoners_file: prisoners_file, aliases_file: aliases_file)
        ImportPrisoners.call(import)
        expect(Import.count).to be 1
      end
    end

    context 'when failing' do
      before do
        expect(ParseCsv).to receive(:call).and_raise(Exception)
      end

      it 'marks the import failed' do
        ImportPrisoners.call(import)
        expect(import.status).to eq('failed')
      end

      it 'sends an email' do
        expect {
          ImportPrisoners.call(import)
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
end
