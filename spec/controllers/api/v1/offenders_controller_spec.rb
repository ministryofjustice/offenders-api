require 'rails_helper'

RSpec.describe Api::V1::OffendersController, type: :controller do
  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }

  context 'when authenticated' do
    before { request.headers['HTTP_AUTHORIZATION'] = "Bearer #{token.token}" }

    describe 'GET #index' do
      it 'returns collection of offender records' do
        create_list(:offender, 2)

        get :index

        expect(JSON.parse(response.body).map { |h| h['id'] })
          .to match_array(Offender.all.pluck(:id))
      end

      it 'paginates records' do
        create_list(:offender, 3)

        get :index, page: '1', per_page: '2'

        expect(JSON.parse(response.body).size).to eq 2

        get :index, page: '2', per_page: '2'

        expect(JSON.parse(response.body).size).to eq 1
      end

      it 'filters records updated after a timestamp' do
        create(:offender, updated_at: 1.year.ago)
        create(:offender, updated_at: 5.days.ago)

        get :index, updated_after: 10.days.ago

        expect(JSON.parse(response.body).size).to eq 1
      end
    end

    describe 'GET #search' do
      let!(:offender_1) do
        create(:offender, noms_id: 'A1234BC')
      end

      let!(:offender_2) do
        create(:offender, noms_id: 'A9876XY')
      end

      let!(:identity_1) do
        create(:identity, offender: offender_1)
      end

      let!(:identity_2) do
        create(:identity, offender: offender_2)
      end

      context 'searching for NOMS ID' do
        context 'when query matches' do
          let(:search_params) { { noms_id: 'A1234BC' } }

          before { get :search, search_params }

          it 'returns collection of offender records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] })
              .to match_array([offender_1['id']])
          end
        end

        context 'when query does not match' do
          let(:search_params) { { noms_id: 'A4567FG' } }

          before { get :search, search_params }

          it 'returns an empty set' do
            expect(response.body).to eq('[]')
          end
        end
      end
    end

    describe 'GET #show' do
      let(:offender) { create(:offender) }

      before { get :show, id: offender }

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'returns JSON represenation of offender record' do
        expect(JSON.parse(response.body).as_json)
          .to include offender.as_json(except: %w(date_of_birth created_at updated_at current_identity_id))
      end
    end
  end

  context 'when unauthenticated' do
    describe 'GET #index' do
      before { get :index }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'GET #search' do
      before { get :search, query: '' }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'GET #show' do
      before { get :show, id: 1 }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end
  end
end
