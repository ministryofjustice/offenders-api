require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe '#import_failed' do
    let(:import) { instance_double('Import') }
    let(:mailer) { described_class.import_failed(import, "Error parsing line 1234").deliver_now }

    before(:each) do
      allow(import).to receive(:created_at).and_return(Time.now)
      allow(import).to receive(:file).and_return("file_path")
    end

    it 'renders the subject' do
      expect(mailer.subject).to eq('Import failed')
    end

    it 'renders the receiver email' do
      expect(mailer.to).to eq(['single-offender-identity@digital.justice.gov.uk'])
    end

    it 'renders the sender email' do
      expect(mailer.from).to eq(['single-offender-identity@digital.justice.gov.uk'])
    end
  end
end
