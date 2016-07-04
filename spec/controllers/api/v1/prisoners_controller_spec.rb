require 'rails_helper'

RSpec.describe Api::V1::PrisonersController, type: :controller do

  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }

  context 'when authenticated' do
    before { request.headers['HTTP_AUTHORIZATION'] = "Bearer #{token.token}" }

    describe 'GET #index' do
      let(:query) { nil }

      before do
        create(:prisoner, given_name: 'john')
        create(:prisoner, given_name: 'james')
        get :index, query: query
      end

      context 'with no query present' do
        it 'returns an empty set' do
          expect(response.body).to eq('[]')
        end
      end

      context 'when query matches' do
        let(:query) { 'john' }

        it 'returns collection of prisoner records' do
          expect(JSON.parse(response.body).map { |h| h['id'] }).to match_array(Prisoner.where(given_name: 'john').pluck(:id))
        end
      end

      context 'when query does not match' do
        let(:query) { 'bob' }

        it 'returns an empty set' do
          expect(response.body).to eq('[]')
        end
      end
    end

    describe 'GET #show' do
      let(:prisoner) { create(:prisoner) }

      before { get :show, id: prisoner }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'returns JSON represenation of prisoner record' do
        expect(response.body).to eq(prisoner.to_json)
      end
    end

    describe 'POST #create' do
      let(:params) do
        {
          given_name: 'John',
          surname: 'Smith',
          offender_id: '134',
          noms_id: 'A1234ZZ',
          date_of_birth: '19711010'
        }
      end

      before { post :create, prisoner: params }

      it 'creates a new Prisoner record' do
        expect(Prisoner.count).to eq(1)
      end

      it 'returns status 201/created' do
        expect(response.status).to eq(201)
      end

      it 'returns "true"' do
        expect(response.body).to eq('true')
      end
    end

    describe 'PATCH #update' do
      let!(:prisoner) { create(:prisoner, noms_id: 'A1234BC', date_of_birth: Date.parse('19801010')) }

      before do
        patch :update, id: prisoner, prisoner: { noms_id: 'B1234BC' }
        prisoner.reload
      end

      it 'updates the prisoner record' do
        expect(prisoner.noms_id).to eq('B1234BC')
      end

      it 'returns status "success"' do
        expect(response.status).to eq(200)
      end

      it 'returns "true"' do
        expect(response.body).to eq('true')
      end
    end

    describe 'DELETE #destroy' do
      let!(:prisoner) { create(:prisoner, noms_id: 'A1234BC', date_of_birth: Date.parse('19801010')) }

      before do
        delete :destroy, id: prisoner
      end

      it 'destroys the prisoner' do
        expect(Prisoner.count).to eq(0)
      end

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'returns "true"' do
        expect(response.body).to eq('true')
      end
    end
  end

  context 'when unauthenticated' do
    describe 'GET #index' do
      before { get :index }

      it 'returns status 401' do
        expect(response.status).to eq(401)
      end
    end

    describe 'GET #show' do
      before { get :show, id: 1 }

      it 'returns status 401' do
        expect(response.status).to eq(401)
      end
    end

    describe 'POST #create' do

    end

    describe 'PATCH #update' do

    end

    describe 'DELETE #destroy' do

    end
  end
end
