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
    let(:prisoner_1) do
      create(:prisoner, given_name: 'DARREN', middle_names: 'MARK JOHN', surname: 'WHITE',
                        noms_id: 'A1234BC', date_of_birth: '19850317', establishment_code: 'LEI',
                        pnc_number: '38/525271A', cro_number: '056339/17X')
    end

    let(:prisoner_2) do
      create(:prisoner, given_name: 'JUSTIN', middle_names: 'JAKE PAUL', surname: 'BLACK',
                        noms_id: 'A9876ZX', date_of_birth: '19791025', establishment_code: 'BMI',
                        pnc_number: '57/215383B', cro_number: '066231/68H')
    end

    let(:prisoner_3) do
      create(:prisoner, given_name: 'ALANIS', middle_names: 'JANIS SOPHIE', surname: 'PURPLE',
                        noms_id: 'A5678JK', date_of_birth: '19661230', establishment_code: 'OUT',
                        pnc_number: '99/135626A', cro_number: '102593/44J')
    end

    let!(:alias_1) do
      create(:alias, prisoner: prisoner_3, given_name: 'TONY', middle_names: 'FRANK ROBERT', surname: 'BROWN')
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
          expect(Prisoner.search(params)).to eq [prisoner_3]
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

    context 'date_of_birth search' do
      context 'when query matches' do
        let(:params) { { date_of_birth: '19661230' } }

        it 'returns matching records' do
          expect(Prisoner.search(params)).to eq [prisoner_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { date_of_birth: '19710309' } }

        it 'returns an empty array' do
          expect(Prisoner.search(params)).to eq []
        end
      end
    end

    context 'pnc_number search' do
      context 'when query matches' do
        let(:params) { { pnc_number: '38/525271A' } }

        it 'returns matching records' do
          expect(Prisoner.search(params)).to eq [prisoner_1]
        end
      end

      context 'when query does not match' do
        let(:params) { { pnc_number: '76/127718Z' } }

        it 'returns an empty array' do
          expect(Prisoner.search(params)).to eq []
        end
      end
    end

    context 'cro_number search' do
      context 'when query matches' do
        let(:params) { { cro_number: '066231/68H' } }

        it 'returns matching records' do
          expect(Prisoner.search(params)).to eq [prisoner_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { cro_number: '319618/23G' } }

        it 'returns an empty array' do
          expect(Prisoner.search(params)).to eq []
        end
      end
    end

    context 'establishment_code search' do
      context 'when query matches' do
        let(:params) { { establishment_code: 'OUT' } }

        it 'returns matching records' do
          expect(Prisoner.search(params)).to eq [prisoner_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { establishment_code: 'BXI' } }

        it 'returns an empty array' do
          expect(Prisoner.search(params)).to eq []
        end
      end
    end

    context 'multiple fields search' do
      context 'when query matches' do
        let(:params) do
          {
            given_name: 'dar',
            surname: 'whi',
            noms_id: 'A1234BC',
            date_of_birth: '19850317',
            establishment_code: 'LEI',
            pnc_number: '38/525271A',
            cro_number: '056339/17X'
          }
        end

        it 'returns matching records' do
          expect(Prisoner.search(params)).to eq [prisoner_1]
        end
      end

      context 'when query does not match' do
        let(:params) do
          {
            given_name: 'jan',
            middle_names: 'rob',
            noms_id: 'A8765IO',
            date_of_birth: '19720911',
            establishment_code: 'LEI',
            pnc_number: '38/525271A',
            cro_number: '056339/17X'
          }
        end

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
          'given_name' => 'ROBERT',
          'middle_names' => 'JAMES DAN',
          'surname' => 'BLACK',
          'title' => 'MR',
          'suffix' => 'DR',
          'date_of_birth' => '19801010',
          'gender' => 'M'
        },
        {
          'given_name' => 'STEVEN',
          'middle_names' => 'TOM PAUL',
          'surname' => 'LITTLE',
          'title' => 'MR',
          'suffix' => 'DR',
          'date_of_birth' => '19780503',
          'gender' => 'M'
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
      excepted_attrs = %w(id created_at updated_at date_of_birth)
      first_alias_attrs = subject.aliases.first.attributes.except(*excepted_attrs)
      last_alias_attrs = subject.aliases.last.attributes.except(*excepted_attrs)
      expect(first_alias_attrs).to include alias_attrs.first.except(*excepted_attrs)
      expect(last_alias_attrs).to include alias_attrs.last.except(*excepted_attrs)
      expect(subject.aliases.first.date_of_birth).to eq Date.parse(alias_attrs.first['date_of_birth'])
      expect(subject.aliases.last.date_of_birth).to eq Date.parse(alias_attrs.last['date_of_birth'])
    end
  end
end
