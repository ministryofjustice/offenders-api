require 'rails_helper'

RSpec.describe Api::V1::IdentitiesController, type: :controller do
  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }
  let(:params) do
    {
      'noms_id' => 'A1234BC',
      'nationality_code' => 'BRIT',
      'establishment_code' => 'LEI',
      'given_name' => 'JOHN',
      'middle_names' => 'FRANK MARK',
      'surname' => 'SMITH',
      'title' => 'MR',
      'suffix' => 'DR',
      'date_of_birth' => '19711010',
      'gender' => 'M',
      'pnc_number' => 'PNC123',
      'cro_number' => 'CRO987'
    }
  end
  let(:excepted_attrs) { %w(id created_at updated_at date_of_birth noms_id nationality_code establishment_code) }

  context 'when authenticated' do
    before { request.headers['HTTP_AUTHORIZATION'] = "Bearer #{token.token}" }

    # describe 'GET #search' do
    #   let!(:identity_1) do
    #     create(:identity, noms_id: 'A1234BC')
    #   end
    #
    #   let!(:identity_2) do
    #     create(:identity, noms_id: 'AB123')
    #   end
    #
    #   let!(:identity_1) do
    #     create(:identity, identity: identity_1, given_name: 'DARREN', middle_names: 'FRANK ROBERT', surname: 'WHITE')
    #   end
    #
    #   let!(:identity_2) do
    #     create(:identity, identity: identity_2, given_name: 'TONY', middle_names: 'FRANK ROBERT', surname: 'BROWN')
    #   end
    #
    #   context 'searching for NOMS ID' do
    #     context 'when query matches' do
    #       let(:search_params) { { noms_id: 'A1234BC' } }
    #
    #       before { get :search, search_params }
    #
    #       it 'returns collection of identity records matching query' do
    #         expect(JSON.parse(response.body).map { |p| p['id'] })
    #           .to match_array([identity_1['id']])
    #       end
    #     end
    #
    #     context 'when query does not match' do
    #       let(:search_params) { { noms_id: 'A9876XY' } }
    #
    #       before { get :search, search_params }
    #
    #       it 'returns an empty set' do
    #         expect(response.body).to eq('[]')
    #       end
    #     end
    #   end
    #
    #   context 'name search' do
    #     context 'when query matches' do
    #       let(:search_params) { { given_name: 'darr', surname: 'whi' } }
    #
    #       before { get :search, search_params }
    #
    #       it 'returns collection of identity records matching query' do
    #         expect(JSON.parse(response.body).map { |p| p['id'] })
    #           .to match_array([identity_1['id']])
    #       end
    #     end
    #
    #     context 'when query does not match' do
    #       let(:search_params) { { given_name: 'luke' } }
    #
    #       before { get :search, search_params }
    #
    #       it 'returns an empty set' do
    #         expect(response.body).to eq('[]')
    #       end
    #     end
    #   end
    # end

    describe 'GET #show' do
      let(:identity) { create(:identity) }

      before { get :show, id: identity }

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'returns JSON represenation of identity record' do
        expect(JSON.parse(response.body).as_json)
          .to include identity.as_json(except: %w(date_of_birth created_at updated_at))
      end
    end

    describe 'POST #create' do
      context 'when valid' do
        context 'when offender is not present' do
          before { post :create, identity: params }

          it 'creates a new identity record with given params' do
            identity = Identity.last
            identity_attrs = identity.attributes.except(*excepted_attrs)
            expect(identity_attrs).to include(params.except(*excepted_attrs))
            expect(identity.date_of_birth).to eq Date.parse(params['date_of_birth'])
          end

          it 'sets current_offender of offender' do
            identity = Identity.last
            expect(identity.offender.current_identity).to eq identity
          end

          it 'returns status 201/created' do
            expect(response.status).to be 201
          end

          it 'returns the id and the offender_id of the created record' do
            identity = Identity.last
            expect(response.body).to eq({ id: identity.id, offender_id: identity.offender.id }.to_json)
          end
        end

        context 'when offender is present' do
          before do
            offender = create(:offender)
            post :create, identity: params.merge(offender_id: offender.id)
          end

          it 'creates a new identity record with given params' do
            identity = Identity.last
            identity_attrs = identity.attributes.except(*excepted_attrs)
            expect(identity_attrs).to include(params.except(*excepted_attrs))
            expect(identity.date_of_birth).to eq Date.parse(params['date_of_birth'])
          end

          it 'does not update current offender' do
            identity = Identity.last
            expect(identity.offender.current_identity).to_not be identity
          end

          it 'returns status 201/created' do
            expect(response.status).to be 201
          end

          it 'returns the id and the offender_id of the created record' do
            identity = Identity.last
            expect(response.body).to eq({ id: identity.id, offender_id: identity.offender.id }.to_json)
          end
        end
      end

      # context 'when invalid' do
      #   before do
      #     params.delete('gender')
      #     post :create, identity: params
      #   end
      #
      #   it 'does not create a identity record' do
      #     expect(Identity.count).to be 0
      #   end
      #
      #   it 'returns status 422/unprocessable entity' do
      #     expect(response.status).to be 422
      #   end
      #
      #   it 'returns error for missing attribute' do
      #     expect(JSON.parse(response.body)).to eq(
      #       'error' => { 'gender' => ['can\'t be blank'] }
      #     )
      #   end
      # end
    end
    #
    # describe 'PATCH #update' do
    #   let!(:identity) { create(:identity, noms_id: 'A1234XX') }
    #
    #   context 'when valid' do
    #     before do
    #       patch :update, id: identity, identity: params
    #       identity.reload
    #     end
    #
    #     it 'updates the identity record' do
    #       identity_attrs = identity.attributes.except(*excepted_attrs)
    #       expect(identity_attrs).to include(params.except(*excepted_attrs))
    #       expect(identity.date_of_birth).to eq Date.parse(params['date_of_birth'])
    #     end
    #
    #     it 'updates identities' do
    #       first_identity_attrs = identity.identities.first.attributes.except(*excepted_attrs)
    #       last_identity_attrs = identity.identities.last.attributes.except(*excepted_attrs)
    #       expect(first_identity_attrs).to include params['identities'].first.except(*excepted_attrs)
    #       expect(last_identity_attrs).to include params['identities'].last.except(*excepted_attrs)
    #       expect(identity.identities.first.date_of_birth).to eq Date.parse(params['identities']first['date_of_birth'])
    #       expect(identity.identities.last.date_of_birth).to eq Date.parse(params['identities'].last['date_of_birth'])
    #     end
    #
    #     it 'returns status "success"' do
    #       expect(response.status).to be 200
    #     end
    #
    #     it 'returns success:true' do
    #       expect(response.body).to eq('{"success":true}')
    #     end
    #   end
    #
    #   context 'when invalid' do
    #     before do
    #       patch :update, id: identity, identity: { noms_id: 'B1234BC', gender: '' }
    #       identity.reload
    #     end
    #
    #     it 'does not update the identity record' do
    #       expect(identity.noms_id).to eq('A1234XX')
    #     end
    #
    #     it 'returns status "unprocessable entity"' do
    #       expect(response.status).to be 422
    #     end
    #
    #     it 'returns JSON error' do
    #       expect(JSON.parse(response.body)).to eq(
    #         'error' => { 'gender' => ['can\'t be blank'] }
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

    # describe 'POST #create' do
    #   before { post :create, identity: params }
    #
    #   it 'returns status 401' do
    #     expect(response.status).to be 401
    #   end
    # end
    #
    # describe 'PATCH #update' do
    #   let(:identity) { create(:identity) }
    #
    #   before do
    #     patch :update, id: identity.id, identity: params
    #   end
    #
    #   it 'returns status 401' do
    #     expect(response.status).to be 401
    #   end
    # end
  end
end
