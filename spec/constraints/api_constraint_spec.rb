require 'rails_helper'

RSpec.describe ApiConstraint do
  describe '#matches?' do
    let(:request) { double }

    context 'when version matches' do
      let(:options) { { version: '1' } }
      let(:returned_result) do
        { accept: 'version=1' }
      end

      subject { ApiConstraint.new(options) }

      before :each do
        allow(request).to receive(:headers).and_return(returned_result)
      end

      it 'returns true' do
        expect(subject.matches?(request)).to eq(true)
      end
    end

    context 'when version does not match' do
      let(:options) { { version: '2' } }
      let(:returned_result) do
        { accept: 'version=1' }
      end

      subject { ApiConstraint.new(options) }

      before :each do
        allow(request).to receive(:headers).and_return(returned_result)
      end

      it 'returns false' do
        expect(subject.matches?(request)).to eq(false)
      end
    end
  end
end
