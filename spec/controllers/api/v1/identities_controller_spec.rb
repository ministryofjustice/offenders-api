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
      'cro_number' => 'CRO987',
      'ethnicity_code' => 'W1'
    }
  end
  let(:offender_attrs) { %w(noms_id establishment_code nationality_code) }
  let(:excepted_attrs) { %w(id created_at updated_at date_of_birth) }

  context 'when authenticated' do
    before { request.headers['HTTP_AUTHORIZATION'] = "Bearer #{token.token}" }

    describe 'GET #index' do
      it 'returns collection of identity records' do
        create_list(:identity, 2, status: 'active')

        get :index

        expect(JSON.parse(response.body).map { |h| h['id'] })
          .to match_array(Identity.all.pluck(:id))
      end

      it 'paginates records' do
        create_list(:identity, 3, status: 'active')

        get :index, params: { page: '1', per_page: '2' }

        expect(JSON.parse(response.body).size).to eq 2
      end

      it 'sets total count in response headers' do
        create_list(:identity, 3, status: 'active')

        get :index

        expect(response.headers['Total-Count']).to eq '3'
      end
    end

    describe 'GET #search' do
      let!(:offender_1) do
        create(:offender, noms_id: 'A1234BC', establishment_code: 'LEI')
      end

      let!(:offender_2) do
        create(:offender, noms_id: 'A9876ZX', establishment_code: 'BMI')
      end

      let!(:identity_1) do
        create(:identity, offender: offender_1,
                          given_name: 'ALANIS', middle_names: 'LENA ROBERTA', surname: 'BROWN',
                          status: 'active', gender: 'M', date_of_birth: '19650807',
                          pnc_number: '74/832963V', cro_number: '195942/38G', ethnicity_code: 'W1')
      end

      let!(:identity_2) do
        create(:identity, offender: offender_1,
                          given_name: 'DEBBY', middle_names: 'LAURA MARTA', surname: 'YELLOW',
                          status: 'active', gender: 'M', date_of_birth: '19691128',
                          pnc_number: '99/135626A', cro_number: '639816/39Y', ethnicity_code: 'A1')
      end

      let!(:identity_3) do
        create(:identity, offender: offender_2,
                          given_name: 'JONAS', middle_names: 'JULIUS', surname: 'CEASAR',
                          status: 'active', gender: 'F', date_of_birth: '19541009',
                          pnc_number: '38/836893N', cro_number: '741860/84F', ethnicity_code: 'B1')
      end

      context 'searching for NOMS ID' do
        context 'when query matches' do
          let(:search_params) { { noms_id: 'A9876ZX' } }

          before { get :search, params: search_params }

          it 'returns collection of identity records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] })
              .to match_array([identity_3['id']])
          end
        end

        context 'when query does not match' do
          let(:search_params) { { noms_id: 'A9876XY' } }

          before { get :search, params: search_params }

          it 'returns an empty set' do
            expect(response.body).to eq('[]')
          end
        end
      end

      context 'name search' do
        context 'when query matches' do
          let(:search_params) { { given_name: 'deb%', surname: 'yellow' } }

          before { get :search, params: search_params }

          it 'returns collection of identity records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] })
              .to match_array([identity_2['id']])
          end
        end

        context 'when query does not match' do
          let(:search_params) { { given_name: 'luke' } }

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
    end

    describe 'GET #show' do
      let(:identity) { create(:identity) }

      context 'when record is found' do
        before { get :show, params: { id: identity } }

        it 'returns status 200' do
          expect(response.status).to be 200
        end

        it 'returns JSON represenation of identity record' do
          expect(JSON.parse(response.body).as_json)
            .to include identity.as_json(except: %w(date_of_birth created_at updated_at), methods: :current)
        end
      end

      context 'when record is not found' do
        before { get :show, params: { id: 'not-present' } }

        it 'returns status 404' do
          expect(response.status).to be 404
        end

        it 'returns JSON represenation of identity record' do
          expect(JSON.parse(response.body)).to eq(
            'error' => "Couldn't find Identity with 'id'=not-present"
          )
        end
      end
    end

    describe 'POST #create' do
      context 'when valid' do
        context 'when offender is not present' do
          before { post :create, params: { identity: params } }

          let(:identity) { Identity.last }

          it 'creates a new identity record with given params' do
            identity_attrs = identity.attributes.except(*excepted_attrs)
            expect(identity_attrs).to include(params.except(*excepted_attrs, *offender_attrs))
            expect(identity.date_of_birth).to eq Date.parse(params['date_of_birth'])
          end

          it 'sets current_offender on the created offender' do
            expect(identity.offender.current_identity).to eq identity
          end

          it 'returns status 201/created' do
            expect(response.status).to be 201
          end

          it 'returns JSON represenation of the created identity record' do
            expect(JSON.parse(response.body).as_json)
              .to include identity.as_json(except: %w(date_of_birth created_at updated_at), methods: :current)
          end
        end

        context 'when offender is present' do
          before do
            offender = create(:offender)
            post :create, params: { identity: params.merge(offender_id: offender.id) }
          end

          let(:identity) { Identity.last }

          it 'creates a new identity record with given params' do
            identity_attrs = identity.attributes.except(*excepted_attrs)
            expect(identity_attrs).to include(params.except(*excepted_attrs, *offender_attrs))
            expect(identity.date_of_birth).to eq Date.parse(params['date_of_birth'])
          end

          it 'does not create a new offender' do
            expect(Offender.count).to be 1
          end

          it 'does not update current_offender field on offender' do
            expect(identity.offender.current_identity).to_not be identity
          end

          it 'returns status 201/created' do
            expect(response.status).to be 201
          end

          it 'returns JSON represenation of the created identity record' do
            expect(JSON.parse(response.body).as_json)
              .to include identity.as_json(except: %w(date_of_birth created_at updated_at), methods: :current)
          end
        end
      end

      context 'when invalid' do
        context 'with validation errors on the identity' do
          before do
            params.delete('gender')
            post :create, params: { identity: params }
          end

          it 'does not create an identity record' do
            expect(Identity.count).to be 0
            # expect(Offender.count).to be 0 TODO: Maybe we should avoid the creation of the offender
          end

          it 'returns status 422/unprocessable entity' do
            expect(response.status).to be 422
          end

          it 'returns error for missing attribute' do
            expect(JSON.parse(response.body)).to eq(
              'error' => { 'gender' => ["can't be blank"] }
            )
          end
        end

        context 'with validation errors on the offender' do
          before do
            params.delete('noms_id')
            post :create, params: { identity: params }
          end

          it 'does not create an identity record' do
            expect(Identity.count).to be 0
            expect(Offender.count).to be 0
          end

          it 'returns status 422/unprocessable entity' do
            expect(response.status).to be 422
          end

          it 'returns error for missing attribute' do
            expect(JSON.parse(response.body)).to eq(
              'error' => { 'noms_id' => ["can't be blank"] }
            )
          end
        end
      end
    end

    describe 'PATCH #update' do
      let!(:identity) { create(:identity, surname: 'BLACK', offender: create(:offender, noms_id: 'A7104HJ')) }

      context 'when valid' do
        before do
          patch :update, params: { id: identity, identity: params }
          identity.reload
        end

        it 'updates the identity record' do
          identity_attrs = identity.attributes.except(*excepted_attrs)
          expect(identity_attrs).to include(params.except(*excepted_attrs, *offender_attrs))
          expect(identity.date_of_birth).to eq Date.parse(params['date_of_birth'])
        end

        it 'updates the offender record' do
          expect(identity.offender.attributes).to include(params.slice(offender_attrs))
        end

        it 'returns status "success"' do
          expect(response.status).to be 200
        end

        it 'returns JSON represenation of identity record' do
          expect(JSON.parse(response.body).as_json)
            .to include identity.as_json(except: %w(date_of_birth created_at updated_at), methods: :current)
        end
      end

      context 'when invalid' do
        context 'with validation errors on the identity' do
          before do
            invalid_params = params.merge('surname' => '')
            patch :update, params: { id: identity, identity: invalid_params }
          end

          it 'does not update the identity record' do
            expect(identity.surname).to eq('BLACK')
          end

          it 'returns status "unprocessable entity"' do
            expect(response.status).to be 422
          end

          it 'returns JSON error' do
            expect(JSON.parse(response.body)).to eq(
              'error' => { 'surname' => ["can't be blank"] }
            )
          end
        end
      end

      context 'with validation errors on the offender' do
        before do
          invalid_params = params.merge('noms_id' => '')
          patch :update, params: { id: identity, identity: invalid_params }
          identity.reload
        end

        it 'does not update the identity record' do
          expect(identity.offender.noms_id).to eq('A7104HJ')
        end

        it 'returns status "unprocessable entity"' do
          expect(response.status).to be 422
        end

        it 'returns JSON error' do
          expect(JSON.parse(response.body)).to eq(
            'error' => { 'noms_id' => ["can't be blank"] }
          )
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:identity) { create(:identity, status: 'active') }

      context 'success' do
        before do
          delete :destroy, params: { id: identity }
          identity.reload
        end

        it 'deletes the identity' do
          expect(identity.status).to eq 'deleted'
        end

        it 'returns status "success"' do
          expect(response.status).to be 200
        end

        it 'returns success:true' do
          expect(response.body).to eq('{"success":true}')
        end
      end

      context 'failure' do
        before do
          identity_double = instance_double(Identity)
          allow(Identity).to receive(:find).and_return(identity_double)
          allow(identity_double).to receive(:soft_delete!).and_return(false)

          delete :destroy, params: { id: identity }
        end

        it 'does not delete the identity' do
          expect(Identity.last.status).to eq 'active'
        end
      end
    end

    describe 'PATCH #activate' do
      let(:identity) { create(:identity, status: 'inactive') }

      context 'success' do
        before do
          patch :activate, params: { id: identity }
          identity.reload
        end

        it 'activates the identity' do
          expect(identity.status).to eq 'active'
        end

        it 'returns status "success"' do
          expect(response.status).to be 200
        end

        it 'returns success:true' do
          expect(response.body).to eq('{"success":true}')
        end
      end

      context 'failure' do
        before do
          identity_double = instance_double(Identity)
          allow(Identity).to receive(:find).and_return(identity_double)
          allow(identity_double).to receive(:make_active!).and_return(false)

          patch :activate, params: { id: identity }
        end

        it 'does not activate the identity' do
          expect(Identity.last.status).to eq 'inactive'
        end
      end
    end

    describe 'PATCH #make_current' do
      let!(:offender) { create(:offender) }
      let!(:identity_1) { create(:identity, surname: 'BLACK', offender: offender) }
      let!(:identity_2) { create(:identity, surname: 'BLACK', offender: offender) }

      before do
        offender.update_attribute(:current_identity, identity_1)
      end

      context 'success' do
        before do
          patch :make_current, params: { id: identity_2 }
          offender.reload
        end

        it 'updates the offender current identity' do
          expect(offender.current_identity).to eq identity_2
        end

        it 'returns status "success"' do
          expect(response.status).to be 200
        end

        it 'returns success:true' do
          expect(response.body).to eq('{"success":true}')
        end
      end

      context 'failure' do
        before do
          offender_double = instance_double(Offender)
          identity_double = instance_double(Identity)
          allow(Identity).to receive(:find).and_return(identity_double)
          allow(identity_double).to receive(:offender).and_return(offender_double)
          allow(offender_double).to receive(:update!).and_return(false)

          patch :make_current, params: { id: identity_2 }

          offender.reload
        end

        it 'does not update the offender current identity' do
          expect(offender.current_identity).to eq identity_1
        end
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

    describe 'POST #create' do
      before { post :create, params: { identity: params } }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'PATCH #update' do
      let(:identity) { create(:identity) }

      before do
        patch :update, params: { id: identity.id, identity: params }
      end

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'DELETE #destroy' do
      let(:identity) { create(:identity) }

      before do
        delete :destroy, params: { id: identity.id }
      end

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'PATCH #activate' do
      let(:identity) { create(:identity) }

      before do
        patch :activate, params: { id: identity.id }
      end

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'PATCH #make_current' do
      let(:identity) { create(:identity) }

      before do
        patch :make_current, params: { id: identity.id }
      end

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end
  end
end
