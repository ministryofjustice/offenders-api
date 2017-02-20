require 'rails_helper'

RSpec.describe Api::V1::OffendersController, type: :controller do
  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }

  let!(:offender_1) do
    create(:offender, noms_id: 'A1234BC')
  end

  let!(:offender_2) do
    create(:offender, noms_id: 'A9876ZX')
  end

  let!(:offender_3) do
    create(:offender, noms_id: 'A4567FG')
  end

  let!(:offender_4) do
    create(:offender, noms_id: 'A9999XX')
  end

  let!(:identity_1) do
    create(:identity, offender: offender_1, status: 'active')
  end

  let!(:identity_2) do
    create(:identity, offender: offender_2, status: 'active')
  end

  let!(:identity_3) do
    create(:identity, offender: offender_3, status: 'active')
  end

  let!(:identity_4) do
    create(:identity, offender: offender_3, status: 'inactive')
  end

  before do
    offender_1.update_attributes current_identity: identity_1, updated_at: 1.year.ago
    offender_2.update_attributes current_identity: identity_2, updated_at: 5.days.ago
    offender_3.update_attributes current_identity: identity_3, updated_at: 20.days.ago
    offender_4.update_attributes current_identity: identity_4, updated_at: 2.days.ago
  end

  context 'when authenticated' do
    before { request.headers['HTTP_AUTHORIZATION'] = "Bearer #{token.token}" }

    describe 'GET #index' do
      it 'returns collection of offender records' do
        get :index

        expect(JSON.parse(response.body).map { |h| h['id'] })
          .to match_array(Offender.active.pluck(:id))
      end

      it 'paginates records' do
        get :index, params: { page: '1', per_page: '2' }

        expect(JSON.parse(response.body).size).to eq 2
      end

      it 'sets total count in response headers' do
        get :index

        expect(response.headers['Total-Count']).to eq '3'
      end

      it 'scopes active offenders' do
        get :index

        expect(JSON.parse(response.body).size).to eq 3
      end

      it 'filters records updated after a timestamp' do
        get :index, params: { updated_after: 10.days.ago }

        expect(JSON.parse(response.body).size).to eq 1
      end
    end

    describe 'GET #search' do
      context 'searching for NOMS ID' do
        context 'when query matches' do
          let(:search_params) { { noms_id: 'A1234BC' } }

          before { get :search, params: search_params }

          it 'returns collection of offender records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] })
              .to match_array([offender_1['id']])
          end
        end

        context 'when query does not match' do
          let(:search_params) { { noms_id: 'A4321KL' } }

          before { get :search, params: search_params }

          it 'returns an empty set' do
            expect(response.body).to eq('[]')
          end
        end
      end

      it 'paginates records' do
        get :search, params: { page: '1', per_page: '2' }

        expect(JSON.parse(response.body).size).to eq 2
      end

      it 'sets total count in response headers' do
        get :search

        expect(response.headers['Total-Count']).to eq '3'
      end

      it 'scopes active offenders' do
        get :search

        expect(JSON.parse(response.body).size).to eq 3
      end
    end

    describe 'GET #show' do
      context 'when offender has not been merged' do
        before { get :show, params: { id: offender_1 } }

        it 'returns status 200' do
          expect(response.status).to be 200
        end

        it 'returns JSON represenation of offender record' do
          excepted_fields = %w(merged_to_id date_of_birth created_at updated_at current_identity_id)
          expect(JSON.parse(response.body).as_json)
            .to include offender_1.as_json(except: excepted_fields)
        end
      end

      context 'when offender has been merged' do
        before do
          offender_1.update(merged_to_id: offender_2.id)
          get :show, params: { id: offender_1 }
        end

        it 'returns status 302' do
          expect(response.status).to be 302
        end

        it 'returns JSON represenation of offender record' do
          excepted_fields = %w(merged_to_id date_of_birth created_at updated_at current_identity_id)
          expect(JSON.parse(response.body).as_json)
            .to include offender_2.as_json(except: excepted_fields)
        end
      end
    end

    describe 'PATCH #merge' do
      let!(:identity_5) do
        create(:identity, offender: offender_1, status: 'active')
      end

      let!(:identity_6) do
        create(:identity, offender: offender_1, status: 'active')
      end

      before do
        params = {
          id: offender_2,
          offender_id: offender_1.id,
          identity_ids: [identity_1.id, identity_2.id, identity_5.id].join(','),
          current_identity_id: identity_2.id
        }
        patch :merge, params: params
      end

      context 'setting identities' do
        it 'sets the passed identity ids to the offender' do
          expect(offender_2.reload.identities.pluck(:id).sort)
            .to eq [identity_1.id, identity_2.id, identity_5.id].sort
        end

        it 'soft deletes the extraneous identities' do
          expect(identity_6.reload.status).to eq 'deleted'
        end
      end

      it 'sets the current_identity of the offender' do
        expect(offender_2.reload.current_identity).to eq identity_2
      end

      it 'sets the merged_to_id of the other offender' do
        expect(offender_1.reload.merged_to_id).to eq offender_2.id
      end

      it 'returns status 204' do
        expect(response.status).to be 204
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
      before { get :search, params: { query: '' } }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'GET #show' do
      before { get :show, params: { id: 1 } }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'PATCH #merge' do
      before { patch :merge, params: { id: 1 } }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end
  end
end
