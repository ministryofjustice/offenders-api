require 'rails_helper'

RSpec.describe ImportProcessor, type: :worker do
  describe '#perform' do
    let(:prisoners_file) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
    let(:aliases_file) { fixture_file_upload('files/aliases.csv', 'text/csv') }
    let(:import) { Import.create(prisoners_file: prisoners_file, aliases_file: aliases_file) }

    it 'invokes ImportPrisoners service' do
      expect(ImportPrisoners).to receive(:call).with(import)
      ImportProcessor.new.perform(import.id)
    end
  end
end
