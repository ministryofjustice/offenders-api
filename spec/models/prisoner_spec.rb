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
    let!(:prisoner_1) do
      create(:prisoner, noms_id: 'A1234BC', date_of_birth: Date.parse('19750201'),
                        given_name: 'DARREN', middle_names: 'MARK JOHN', surname: 'WHITE')
    end

    let!(:prisoner_2) do
      create(:prisoner, noms_id: 'A9876ZX', date_of_birth: Date.parse('19771127'),
                        given_name: 'JUSTIN', middle_names: 'JAKE PAUL', surname: 'BLACK')
    end

    let!(:prisoner_3) do
      create(:prisoner, noms_id: 'A5678JK', date_of_birth: Date.parse('19800718'),
                        given_name: 'ALANIS', middle_names: 'JANIS SOPHIE', surname: 'PURPLE')
    end

    let!(:alias_1) do
      create(:alias, prisoner: prisoner_1, given_name: 'TONY', middle_names: 'FRANK ROBERT', surname: 'BROWN')
    end

    context 'dob_noms search' do
      context 'when query matches' do
        let(:params) do
          {
            dob_noms: [
              { noms_id: 'A1234BC', date_of_birth: Date.parse('19750201') },
              { noms_id: 'A5678JK', date_of_birth: Date.parse('19800718') },
              { noms_id: 'A6543RE', date_of_birth: Date.parse('19771127') }
            ]
          }
        end

        it 'returns matching records' do
          expect(Prisoner.search(params)).to eq [prisoner_1, prisoner_3]
        end
      end

      context 'when query does not match' do
        let(:params) do
          {
            dob_noms: [
              { noms_id: 'CC123', date_of_birth: Date.parse('19750201') }
            ]
          }
        end

        it 'returns an empty array' do
          expect(Prisoner.search(params)).to eq []
        end
      end
    end

    context 'name search' do
      context 'when query matches' do
        let(:params) { { given_name: 'darr', surname: 'whi' } }

        it 'returns matching records' do
          expect(Prisoner.search(params)).to eq [prisoner_1]
        end
      end

      context 'when query matches an alias' do
        let(:params) { { middle_names: 'rob', surname: 'bro' } }

        it 'returns matching records' do
          expect(Prisoner.search(params)).to eq [prisoner_1]
        end
      end

      context 'when query does not match' do
        let(:params) { { given_name: 'luke' } }

        it 'returns an empty array' do
          expect(Prisoner.search(params)).to eq []
        end
      end
    end

    context 'noms_id search' do
      context 'when query matches' do
        let(:params) { { noms_id: 'A9876ZX' } }

        it 'returns matching records' do
          expect(Prisoner.search(params)).to eq [prisoner_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { noms_id: 'X1234FG' } }

        it 'returns an empty array' do
          expect(Prisoner.search(params)).to eq []
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
