require 'rails_helper'

RSpec.describe Prisoner, type: :model do
  subject { create(:prisoner, noms_id: 'A123BC', date_of_birth: Date.parse('19750201')) }

  it { is_expected.to have_many(:aliases) }

  it { is_expected.to validate_presence_of(:noms_id) }
  it { is_expected.to validate_uniqueness_of(:noms_id).scoped_to(:date_of_birth) }
  it { is_expected.to validate_presence_of(:given_name) }
  it { is_expected.to validate_presence_of(:surname) }
  it { is_expected.to validate_presence_of(:date_of_birth) }
  it { is_expected.to validate_presence_of(:gender) }

  describe '.search' do
    let(:params) do
      nil
    end

    let!(:prisoner_1) do
      create(:prisoner, noms_id: 'AA123', date_of_birth: Date.parse('19750201'))
    end

    let!(:prisoner_2) do
      create(:prisoner, noms_id: 'AB123', date_of_birth: Date.parse('19750201'))
    end

    let!(:prisoner_3) do
      create(:prisoner, noms_id: 'AC123', date_of_birth: Date.parse('19650201'))
    end

    context 'params not present' do
      it 'returns an empty set' do
        expect(Prisoner.search(params)).to eq([])
      end
    end

    context 'params present' do
      context 'no matching records exist' do
        let(:params) do
          [
            { noms_id: 'CC123', date_of_birth: Date.parse('19750201') }
          ]
        end

        it 'returns matching records' do
          expect(Prisoner.search(params)).to match_array([])
        end
      end

      context 'searching for multiple records' do
        let(:params) do
          [
            { noms_id: 'AA123', date_of_birth: Date.parse('19750201') },
            { noms_id: 'AC123', date_of_birth: Date.parse('19650201') },
            { noms_id: 'AZ123', date_of_birth: Date.parse('19650201') }
          ]
        end

        it 'returns matching records' do
          expect(Prisoner.search(params)).to match_array([prisoner_1, prisoner_3])
        end
      end

      context 'searching for single record' do
        let(:params) do
          [
            { noms_id: 'AC123', date_of_birth: Date.parse('19650201') }
          ]
        end

        it 'returns matching record' do
          expect(Prisoner.search(params)).to match_array([prisoner_3])
        end
      end
    end
  end

  describe '#update_aliases' do
    let(:alias_attrs) do
      [
        {
          "given_name" => 'ROBERT',
          "middle_names" => 'JAMES DAN',
          "surname" => 'BLACK',
          "title" => 'MR',
          "suffix" => 'DR',
          "date_of_birth" => '19801010',
          "gender" => 'M'
        },
        {
          "given_name" => 'STEVEN',
          "middle_names" => 'TOM PAUL',
          "surname" => 'LITTLE',
          "title" => 'MR',
          "suffix" => 'DR',
          "date_of_birth" => '19780503',
          "gender" => 'M'
        }
      ]
    end

    before do
      create(:alias, prisoner: subject, given_name: 'GIVEN_NAME')
      subject.update_aliases(alias_attrs)
    end

    it 'deletes all previous aliases' do
      expect(Alias.where(given_name: 'GIVEN_NAME')).to be_empty
    end

    it 'sets the new aliases' do
      excepted_attrs = %w[id created_at updated_at date_of_birth]
      first_alias_attrs = subject.aliases.first.attributes.except(*excepted_attrs)
      last_alias_attrs = subject.aliases.last.attributes.except(*excepted_attrs)
      expect(first_alias_attrs).to include alias_attrs.first.except(*excepted_attrs)
      expect(last_alias_attrs).to include alias_attrs.last.except(*excepted_attrs)
      expect(subject.aliases.first.date_of_birth).to eq Date.parse(alias_attrs.first["date_of_birth"])
      expect(subject.aliases.last.date_of_birth).to eq Date.parse(alias_attrs.last["date_of_birth"])
    end
  end
end
