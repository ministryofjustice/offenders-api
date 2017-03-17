require 'rails_helper'

RSpec.describe ImportOffenders do
  let(:import) { Import.create(offenders_file: offenders_file) }

  describe '#call' do
    context 'when successful' do
      let(:offenders_file) { fixture_file_upload('files/data.csv', 'text/csv') }

      it 'calls the parse csv service with the data' do
        expect(ParseOffenders).to receive(:call).with(import.offenders_file.file.file).and_return([])
        ImportOffenders.call(import)
      end

      it 'marks the import successful' do
        ImportOffenders.call(import)
        expect(import.status).to eq('successful')
      end

      it 'removes all other imports' do
        Import.create(offenders_file: offenders_file)
        ImportOffenders.call(import)
        expect(Import.count).to be 1
      end
    end

    context 'when failing' do
      let(:offenders_file) { fixture_file_upload('files/invalid_data.csv', 'text/csv') }

      it 'marks the import failed' do
        ImportOffenders.call(import)
        expect(import.status).to eq('failed')
      end

      it 'sends an email' do
        expect { ImportOffenders.call(import) }
          .to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
end
