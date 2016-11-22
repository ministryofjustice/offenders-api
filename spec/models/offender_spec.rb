require 'rails_helper'

RSpec.describe Offender, type: :model do
  subject { create(:offender, noms_id: 'A123BC') }

  it { is_expected.to have_many(:identities) }
  it { is_expected.to belong_to(:current_identity) }

  it { is_expected.to validate_presence_of(:noms_id) }
  it { is_expected.to validate_uniqueness_of(:noms_id) }

  describe '.search' do
    let!(:offender_1) do
      create(:offender, noms_id: 'A1234BC', establishment_code: 'LEI')
    end

    let!(:offender_2) do
      create(:offender, noms_id: 'A9876ZX', establishment_code: 'BMI')
    end

    let!(:offender_3) do
      create(:offender, noms_id: 'A5678JK', establishment_code: 'OUT')
    end

    let!(:identity_1) do
      create(:identity, offender: offender_3,
                        given_name: 'ALANIS', middle_names: 'LENA ROBERTA', surname: 'BROWN',
                        gender: 'M', date_of_birth: '19650807', pnc_number: '74/832963V', cro_number: '195942/38G')
    end

    let!(:identity_2) do
      create(:identity, offender: offender_3,
                        given_name: 'DEBBY', middle_names: 'LAURA MARTA', surname: 'BROWN',
                        gender: 'M', date_of_birth: '19691128', pnc_number: '99/135626A', cro_number: '639816/39Y')
    end

    let!(:identity_3) do
      create(:identity, offender: offender_1,
                        given_name: 'JONAS', middle_names: 'JULIUS', surname: 'CEASAR',
                        gender: 'F', date_of_birth: '19541009', pnc_number: '74/836893N', cro_number: '741860/84F')
    end

    let!(:identity_4) do
      create(:identity, offender: offender_2, given_name: 'HIMAL', middle_names: 'CESI', surname: 'BLUE',
                        gender: 'F', date_of_birth: '19920214', pnc_number: '35/742693J', cro_number: '867186/74G')
    end

    context 'name search' do
      context 'when query matches' do
        let(:params) { { given_name: 'ala', surname: 'bro' } }

        it 'returns matching records' do
          expect(Offender.search(params)).to eq [offender_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { given_name: 'luke' } }

        it 'returns an empty array' do
          expect(Offender.search(params)).to eq []
        end
      end
    end

    context 'noms_id search' do
      context 'when query matches' do
        let(:params) { { noms_id: 'A9876ZX' } }

        it 'returns matching records' do
          expect(Offender.search(params)).to eq [offender_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { noms_id: 'X1234FG' } }

        it 'returns an empty array' do
          expect(Offender.search(params)).to eq []
        end
      end
    end

    context 'date_of_birth search' do
      context 'when query matches' do
        let(:params) { { date_of_birth: '19691128' } }

        it 'returns matching records' do
          expect(Offender.search(params)).to eq [offender_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { date_of_birth: '19710309' } }

        it 'returns an empty array' do
          expect(Offender.search(params)).to eq []
        end
      end
    end

    context 'pnc_number search' do
      context 'when query matches' do
        let(:params) { { pnc_number: '74/832963V' } }

        it 'returns matching records' do
          expect(Offender.search(params)).to eq [offender_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { pnc_number: '76/127718Z' } }

        it 'returns an empty array' do
          expect(Offender.search(params)).to eq []
        end
      end
    end

    context 'cro_number search' do
      context 'when query matches' do
        let(:params) { { cro_number: '639816/39Y' } }

        it 'returns matching records' do
          expect(Offender.search(params)).to eq [offender_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { cro_number: '319618/23G' } }

        it 'returns an empty array' do
          expect(Offender.search(params)).to eq []
        end
      end
    end

    context 'establishment_code search' do
      context 'when query matches' do
        let(:params) { { establishment_code: 'OUT' } }

        it 'returns matching records' do
          expect(Offender.search(params)).to eq [offender_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { establishment_code: 'BXI' } }

        it 'returns an empty array' do
          expect(Offender.search(params)).to eq []
        end
      end
    end

    context 'gender search' do
      context 'when query matches' do
        let(:params) { { gender: 'M' } }

        it 'returns matching records' do
          expect(Offender.search(params)).to eq [offender_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { gender: 'NS' } }

        it 'returns an empty array' do
          expect(Offender.search(params)).to eq []
        end
      end
    end

    context 'multiple fields search' do
      context 'when query matches' do
        let(:params) do
          {
            given_name: 'jon',
            surname: 'cea',
            noms_id: 'A1234BC',
            date_of_birth: '19541009',
            gender: 'F',
            establishment_code: 'LEI',
            pnc_number: '74/836893N',
            cro_number: '741860/84F'
          }
        end

        it 'returns matching records' do
          expect(Offender.search(params)).to eq [offender_1]
        end
      end

      context 'when query does not match' do
        let(:params) do
          {
            given_name: 'jan',
            middle_names: 'rob',
            noms_id: 'A8765IO',
            date_of_birth: '19720911',
            gender: 'M',
            establishment_code: 'LEI',
            pnc_number: '38/525271A',
            cro_number: '056339/17X'
          }
        end

        it 'returns an empty array' do
          expect(Offender.search(params)).to eq []
        end
      end
    end

    # context 'ordering' do
    #   it 'orders record by surname, given_name, middle_names' do
    #     binding.pry
    #
    #     expect(Offender.search({})).to eq [offender_2, offender_3, offender_1]
    #   end
    # end
  end

  # describe '#update_identities' do
  #   let(:identity_attrs) do
  #     [
  #       {
  #         'given_name' => 'ROBERT',
  #         'middle_names' => 'JAMES DAN',
  #         'surname' => 'BLACK',
  #         'title' => 'MR',
  #         'suffix' => 'DR',
  #         'date_of_birth' => '19801010',
  #         'gender' => 'M'
  #       },
  #       {
  #         'given_name' => 'STEVEN',
  #         'middle_names' => 'TOM PAUL',
  #         'surname' => 'LITTLE',
  #         'title' => 'MR',
  #         'suffix' => 'DR',
  #         'date_of_birth' => '19780503',
  #         'gender' => 'M'
  #       }
  #     ]
  #   end
  #
  #   before { create(:identity, offender: subject, given_name: 'GIVEN_NAME') }
  #
  #   context 'when identities is not nil' do
  #     before { subject.update_identities(identity_attrs) }
  #
  #     it 'deletes all previous identities' do
  #       expect(Identity.where(given_name: 'GIVEN_NAME')).to be_empty
  #     end
  #
  #     it 'sets the new identities' do
  #       excepted_attrs = %w(id created_at updated_at date_of_birth)
  #       first_identity_attrs = subject.identities.first.attributes.except(*excepted_attrs)
  #       last_identity_attrs = subject.identities.last.attributes.except(*excepted_attrs)
  #       expect(first_identity_attrs).to include identity_attrs.first.except(*excepted_attrs)
  #       expect(last_identity_attrs).to include identity_attrs.last.except(*excepted_attrs)
  #       expect(subject.identities.first.date_of_birth).to eq Date.parse(identity_attrs.first['date_of_birth'])
  #       expect(subject.identities.last.date_of_birth).to eq Date.parse(identity_attrs.last['date_of_birth'])
  #     end
  #   end
  #
  #   context 'when identities is nil' do
  #     before { subject.update_identities(nil) }
  #
  #     it 'does not delete previous identities' do
  #       expect(Identity.where(given_name: 'GIVEN_NAME')).to_not be_empty
  #     end
  #   end
  # end
end
