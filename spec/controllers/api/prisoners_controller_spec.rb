require 'rails_helper'

RSpec.describe Api::PrisonersController, type: :controller do

  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }

  context 'when authenticated' do
    before { request.headers['HTTP_AUTHORIZATION'] = "Bearer #{token.token}" }

    describe 'GET #index' do
      before { get :index }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end
    end

    describe 'GET #search' do
      context 'missing required params' do
        before { get :search }

        it 'should return status 400' do
          expect(response.status).to eq(400)
        end

        it 'returns JSON with error message' do
          expect(JSON.parse(response.body)['error']).to eq('NOMS ID or date of birth not present')
        end
      end

      context 'required params present' do
        let(:prisoner) { create(:prisoner, noms_id: 'A1234BC', date_of_birth: Date.parse('19801010')) }
        let(:params) { { noms_id: prisoner.noms_id, date_of_birth: prisoner.date_of_birth }}

        before { get :search, params }

        context 'no matching record found' do
          let(:params) { { noms_id: 'A999ZZ', date_of_birth: Date.today }}

          it 'returns status 200' do
            expect(response.status).to eq(200)
          end

          it 'returns JSON signifying record not found' do
            expect(JSON.parse(response.body)).to eq({ 'found' => false })
          end
        end

        context 'matching record found' do
          let(:expected_response) do
            { 'found' => true, 'offender' => { 'id' => prisoner.offender_id } }
          end

          it 'returns status 200' do
            expect(response.status).to eq(200)
          end

          it 'returns JSON signifying record found with offender id' do
            expect(JSON.parse(response.body)).to eq(expected_response)
          end
        end
      end
    end

    describe 'GET #show' do
      let(:prisoner) { create(:prisoner) }

      before { get :show, id: prisoner }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end
    end

    describe 'POST #create' do

    end

    describe 'PATCH #update' do

    end

    describe 'DELETE #destroy' do

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
