require 'rails_helper'

RSpec.describe ApiConstraint do
  describe '#matches?' do
    let(:options_version) { 1 }
    let(:accept_version) { 1 }
    let(:request) { instance_double('ActionDispatch::Request') }
    let(:options) { { version: options_version } }
    let(:returned_result) do
      { accept: "version=#{accept_version}" }
    end

    subject { ApiConstraint.new(options) }

    before :each do
      allow(request).to receive(:headers).and_return(returned_result)
    end

    context 'when version not specified' do
      let(:returned_result) { {} }

      it 'returns true' do
        expect(subject.matches?(request)).to eq(true)
      end
    end

    context 'when version matches' do
      it 'returns true' do
        expect(subject.matches?(request)).to eq(true)
      end
    end

    context 'when version does not match' do
      let(:accept_version) { '2' }

      it 'returns false' do
        expect(subject.matches?(request)).to eq(false)
      end
    end
  end
end
