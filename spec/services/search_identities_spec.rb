require 'rails_helper'

RSpec.describe SearchIdentities do
  describe '#call' do
    before { ParseNicknames.call(fixture_file_upload('files/nicknames.csv', 'text/csv')) }

    let!(:offender_1) do
      create(:offender, noms_id: 'A1234BC', establishment_code: 'LEI')
    end

    let!(:offender_2) do
      create(:offender, noms_id: 'A9876ZX', establishment_code: 'BMI')
    end

    let!(:identity_1) do
      create(:identity, offender: offender_1,
                        given_name_1: 'ALANIS', given_name_2: 'LENA', given_name_3: 'ROBERTA', surname: 'BROWN',
                        gender: 'M', date_of_birth: '19650807',
                        pnc_number: '74/832963V^89/652734H', cro_number: '195942/38G^672348/56H', ethnicity_code: 'W1')
    end

    let!(:identity_2) do
      create(:identity, offender: offender_1,
                        given_name_1: 'DEBBY', given_name_2: 'LAURA', given_name_3: 'MARTA', surname: 'SMITH',
                        gender: 'M', date_of_birth: '19691128',
                        pnc_number: '99/135626A^76/198452G', cro_number: '639816/39Y^8374635/82K', ethnicity_code: 'B1')
    end

    let!(:identity_3) do
      create(:identity, offender: offender_2,
                        given_name_1: 'JONAS', given_name_2: 'JULIUS', surname: 'CEASAR',
                        gender: 'F', date_of_birth: '19541009',
                        pnc_number: '38/836893N^10/3740173J', cro_number: '741860/84F^283745/61A', ethnicity_code: 'A1')
    end

    context 'name search' do
      context 'when query matches' do
        let(:params) { { given_name_1: 'alanis', surname: 'brown' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_1]
        end
      end

      context 'when query matches with wildcard characters' do
        let(:params) { { given_name_1: 'ala%', surname: 'br_wn' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_1]
        end
      end

      context 'when query matches with exact surname' do
        let(:params) { { surname: 'brown', exact_surname: 'Y' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_1]
        end
      end

      context 'when query does not match with exact surname' do
        let(:params) { { surname: 'br_wn', exact_surname: 'Y' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end

      context 'when query matches with name switch on' do
        let(:params) { { given_name_1: 'brown', surname: 'alanis', name_switch: 'Y' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_1]
        end
      end

      context 'when query matches with name variation on' do
        let(:params) { { given_name_1: 'deborah', name_variation: 'Y' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_2]
        end
      end

      context 'when query matches with name variation on but no nicknames' do
        let(:params) { { given_name_1: 'jonas', name_variation: 'Y' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_3]
        end
      end

      context 'when query matches with suoundex on' do
        let(:params) { { surname: 'schmitt', soundex: 'Y' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_2]
        end
      end

      context 'when query matches with name_switch and exact_surname on' do
        let(:params) { { given_name_1: 'brown', surname: 'alanis', name_switch: 'Y', exact_surname: 'Y' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_1]
        end
      end

      context 'when query does not match' do
        let(:params) { { given_name_1: 'luke' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'noms_id search' do
      context 'when query matches' do
        let(:params) { { noms_id: 'A1234BC' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_1, identity_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { noms_id: 'X1234FG' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'date_of_birth search' do
      context 'when query matches' do
        let(:params) { { date_of_birth: '19691128' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { date_of_birth: '19710309' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'date_of_birth in range search' do
      context 'when query matches' do
        let(:params) { { date_of_birth_from: '19680101', date_of_birth_to: '19700101' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { date_of_birth_from: '19720101', date_of_birth_to: '19740101' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'ethnicity_code search' do
      context 'when query matches' do
        let(:params) { { ethnicity_code: 'A1' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { ethnicity_code: 'W2' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'pnc_number search' do
      context 'when query matches with wildcard characters' do
        let(:params) { { pnc_number: '%38/836893N%' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { pnc_number: '%76/127718Z%' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'cro_number search' do
      context 'when query matches with wildcard characters' do
        let(:params) { { cro_number: '%195942/38G%' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_1]
        end
      end

      context 'when query does not match' do
        let(:params) { { cro_number: '319618/23G' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'establishment_code search' do
      context 'when query matches' do
        let(:params) { { establishment_code: 'BMI' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_3]
        end
      end

      context 'when query does not match' do
        let(:params) { { establishment_code: 'BXI' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'gender search' do
      context 'when query matches' do
        let(:params) { { gender: 'M' } }

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_1, identity_2]
        end
      end

      context 'when query does not match' do
        let(:params) { { gender: 'NS' } }

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'multiple fields search' do
      context 'when query matches' do
        let(:params) do
          {
            given_name_1: 'jon%',
            surname: 'ceasar',
            noms_id: 'A9876ZX',
            date_of_birth: '19541009',
            gender: 'F',
            establishment_code: 'BMI',
            ethnicity_code: 'A1',
            pnc_number: '%38/836893N%',
            cro_number: '%741860/84F%'
          }
        end

        it 'returns matching records' do
          expect(described_class.new(params).call).to eq [identity_3]
        end
      end

      context 'when query does not match' do
        let(:params) do
          {
            given_name_1: 'jan',
            given_name_2: 'rob',
            noms_id: 'A8765IO',
            date_of_birth: '19720911',
            gender: 'M',
            establishment_code: 'LEI',
            ethnicity_code: 'B1',
            pnc_number: '38/525271A',
            cro_number: '056339/17X'
          }
        end

        it 'returns an empty array' do
          expect(described_class.new(params).call).to eq []
        end
      end
    end

    context 'ordering' do
      it 'orders record by surname, given_name_1' do
        expect(described_class.new({}).call).to eq [identity_1, identity_3, identity_2]
      end
    end

    context 'count and group by surname' do
      let(:params) { { count: 'true' } }
      let(:expected_response) do
        [
          { surname: 'BROWN', count: 1 },
          { surname: 'CEASAR', count: 1 },
          { surname: 'SMITH', count: 1 }
        ]
      end

      it 'returns group by count by surname' do
        expect(described_class.new(params).call).to eq(expected_response)
      end
    end
  end
end
