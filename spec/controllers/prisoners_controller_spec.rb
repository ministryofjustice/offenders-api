require 'rails_helper'

RSpec.describe PrisonersController, type: :controller do
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

    describe 'GET #show' do
      before { get :show, id: 1 }

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
