require 'rails_helper'

RSpec.describe ProcessImportJob, type: :job do
  let(:offenders_file) { fixture_file_upload('files/offenders.csv', 'text/csv') }
  let(:identities_file) { fixture_file_upload('files/identities.csv', 'text/csv') }
  let(:import) { Import.create(offenders_file: offenders_file, identities_file: identities_file) }

  it 'invokes ImportOffenders service' do
    expect(ImportOffenders).to receive(:call).with(import)
    described_class.new.perform(import)
  end
end
