require 'rails_helper'

RSpec.describe Api::V1::PrisonersController, type: :controller do

  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }

  context 'when authenticated' do
    before { request.headers['HTTP_AUTHORIZATION'] = "Bearer #{token.token}" }

    describe 'GET #index' do
      it 'returns collection of prisoner records' do
        create_list(:prisoner, 2)

        get :index

        expect(JSON.parse(response.body).map { |h| h['id'] }).
          to match_array(Prisoner.all.pluck(:id))
      end

      it 'paginates records' do
        create_list(:prisoner, 3)

        get :index, { page: '1', per_page: '2' }

        expect(JSON.parse(response.body).size).to eq 2

        get :index, { page: '2', per_page: '2' }

        expect(JSON.parse(response.body).size).to eq 1
      end

      it 'filters records updated after a timestamp' do
        create(:prisoner, updated_at: 1.year.ago)
        create(:prisoner, updated_at: 5.days.ago)

        get :index, { updated_after: 10.days.ago }

        expect(JSON.parse(response.body).size).to eq 1
      end
    end

    describe 'GET #search' do
      let(:query) { nil }

      let!(:prisoner_1) do
        create(:prisoner, noms_id: 'AA123', date_of_birth: Date.parse('19750201'))
      end

      let!(:prisoner_2) do
        create(:prisoner, noms_id: 'AB123', date_of_birth: Date.parse('19750201'))
      end

      before do
        get :search, query: query
      end

      context 'with no query present' do
        it 'returns an empty set' do
          expect(response.body).to eq('[]')
        end
      end

      context 'when query matches' do
        let(:query) do
          [
            { noms_id: 'AA123', date_of_birth: Date.parse('19750201') }
          ]
        end

        it 'returns collection of prisoner records matching query' do
          expect(JSON.parse(response.body).map { |p| p['id'] }).
            to match_array([prisoner_1['id']])
        end
      end

      context 'when query does not match' do
        let(:query) do
          [
            { noms_id: 'AA123', date_of_birth: Date.parse('19650201') }
          ]
        end

        it 'returns an empty set' do
          expect(response.body).to eq('[]')
        end
      end
    end

    describe 'GET #show' do
      let(:prisoner) { create(:prisoner) }

      before { get :show, id: prisoner }

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'returns JSON represenation of prisoner record' do
        expect(JSON.parse(response.body).as_json).
          to include prisoner.as_json(except: %w[suffix date_of_birth created_at updated_at])
      end
    end

    describe 'GET #noms' do
      let(:prisoner) { create(:prisoner, noms_id: 'A1234BC') }

      before { get :noms, id: prisoner.noms_id }

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'returns JSON represenation of prisoner record' do
        expect(JSON.parse(response.body).as_json).
          to include prisoner.as_json(except: %w[suffix date_of_birth created_at updated_at])
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

    describe 'GET #noms' do
      before { get :noms, id: 'A1234BC' }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end
  end
end
