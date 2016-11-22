# require 'rails_helper'
#
# RSpec.describe ImportOffenders do
#   let(:offenders_file) { fixture_file_upload('files/offenders.csv', 'text/csv') }
#   let(:identities_file) { fixture_file_upload('files/identities.csv', 'text/csv') }
#
#   let(:import) { Import.create(offenders_file: offenders_file, identities_file: identities_file) }
#
#   describe '#call' do
#     context 'when successful' do
#       it 'calls the parse csv service with the data' do
#         expect(ParseCsv).to receive(:call).with(import.offenders_file.read)
#         expect(ParseCsv).to receive(:call).with(import.identities_file.read)
#         ImportOffenders.call(import)
#       end
#
#       it 'marks the import successful' do
#         ImportOffenders.call(import)
#         expect(import.status).to eq('successful')
#       end
#
#       it 'removes all other imports' do
#         Import.create(offenders_file: offenders_file, identities_file: identities_file)
#         ImportOffenders.call(import)
#         expect(Import.count).to be 1
#       end
#     end
#
#     context 'when failing' do
#       before do
#         expect(ParseCsv).to receive(:call).and_raise(StandardError)
#       end
#
#       it 'marks the import failed' do
#         ImportOffenders.call(import)
#         expect(import.status).to eq('failed')
#       end
#
#       it 'sends an email' do
#         expect { ImportOffenders.call(import) }
#           .to change(ActionMailer::Base.deliveries, :count).by(1)
#       end
#     end
#   end
# end
