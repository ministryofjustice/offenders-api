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

        expect(JSON.parse(response.body).map { |h| h['id'] }).to match_array(Prisoner.all.pluck(:id))
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

    # describe 'GET #search' do
    #   let(:query) { nil }
    #
    #   before do
    #     create(:prisoner, given_name: 'john')
    #     create(:prisoner, given_name: 'james')
    #     get :search, query: query
    #   end
    #
    #   context 'with no query present' do
    #     it 'returns an empty set' do
    #       expect(response.body).to eq('[]')
    #     end
    #   end
    #
    #   context 'when query matches' do
    #     let(:query) { 'john' }
    #
    #     it 'returns collection of prisoner records' do
    #       expect(JSON.parse(response.body).map { |h| h['id'] }).to match_array(Prisoner.where(given_name: 'john').pluck(:id))
    #     end
    #   end
    #
    #   context 'when query does not match' do
    #     let(:query) { 'bob' }
    #
    #     it 'returns an empty set' do
    #       expect(response.body).to eq('[]')
    #     end
    #   end
    # end

    describe 'GET #show' do
      let(:prisoner) { create(:prisoner) }

      before { get :show, id: prisoner }

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'returns JSON represenation of prisoner record' do
        expect(JSON.parse(response.body).except('links').to_json).to eq(prisoner.to_json)
      end
    end

    # describe 'POST #create' do
    #   let(:params) do
    #     {
    #       given_name: 'John',
    #       surname: 'Smith',
    #       offender_id: '134',
    #       noms_id: 'A1234ZZ',
    #       date_of_birth: '19711010',
    #       gender: 'M'
    #     }
    #   end
    #
    #   context 'when valid' do
    #     before { post :create, prisoner: params }
    #
    #     it 'creates a new Prisoner record' do
    #       expect(Prisoner.count).to be 1
    #     end
    #
    #     it 'returns status 201/created' do
    #       expect(response.status).to be 201
    #     end
    #
    #     it 'returns the id of the created record' do
    #       expect(response.body).to eq(Prisoner.first.id)
    #     end
    #   end
    #
    #   context 'when invalid' do
    #     before { params.delete(:gender); post :create, prisoner: params }
    #
    #     it 'does not create a Prisoner record' do
    #       expect(Prisoner.count).to be 0
    #     end
    #
    #     it 'returns status 422/unprocessable entity' do
    #       expect(response.status).to be 422
    #     end
    #
    #     it 'returns error for missing attribute' do
    #       expect(JSON.parse(response.body)).to eq(
    #         { 'error' => { 'gender' => ['can\'t be blank'] } }
    #       )
    #     end
    #   end
    # end
    #
    # describe 'PATCH #update' do
    #   let!(:prisoner) { create(:prisoner, noms_id: 'A1234BC', date_of_birth: Date.parse('19801010')) }
    #
    #   context 'when valid' do
    #     before do
    #       patch :update, id: prisoner, prisoner: { noms_id: 'B1234BC' }
    #       prisoner.reload
    #     end
    #
    #     it 'updates the prisoner record' do
    #       expect(prisoner.noms_id).to eq('B1234BC')
    #     end
    #
    #     it 'returns status "success"' do
    #       expect(response.status).to be 200
    #     end
    #
    #     it 'returns "true"' do
    #       expect(response.body).to eq('true')
    #     end
    #   end
    #
    #   context 'when invalid' do
    #     before do
    #       patch :update, id: prisoner, prisoner: { noms_id: 'B1234BC', gender: '' }
    #       prisoner.reload
    #     end
    #
    #     it 'does not update the prisoner record' do
    #       expect(prisoner.noms_id).to eq('A1234BC')
    #     end
    #
    #     it 'returns status "unprocessable entity"' do
    #       expect(response.status).to be 422
    #     end
    #
    #     it 'returns JSON error' do
    #       expect(JSON.parse(response.body)).to eq(
    #         { 'error' => { 'gender' => ['can\'t be blank'] } }
    #       )
    #     end
    #   end
    # end
  end

  context 'when unauthenticated' do
    describe 'GET #index' do
      before { get :index }

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

    # describe 'POST #create' do
    #   before { post :create, prisoner: {
    #       given_name: 'John',
    #       surname: 'Smith',
    #       offender_id: '134',
    #       noms_id: 'A1234ZZ',
    #       date_of_birth: '19711010',
    #       gender: 'M'
    #     }
    #   }
    #
    #   it 'returns status 401' do
    #     expect(response.status).to be 401
    #   end
    # end
    #
    # describe 'PATCH #update' do
    #   let(:prisoner) { create(:prisoner) }
    #
    #   before { post :update, id: prisoner.id, prisoner: {
    #       given_name: 'John',
    #       surname: 'Smith',
    #       offender_id: '134',
    #       noms_id: 'A1234ZZ',
    #       date_of_birth: '19711010',
    #       gender: 'M'
    #     }
    #   }
    #
    #   it 'returns status 401' do
    #     expect(response.status).to be 401
    #   end
    # end
  end
end
