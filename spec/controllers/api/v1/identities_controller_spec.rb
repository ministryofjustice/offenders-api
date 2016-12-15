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
  let(:offender_attrs) { %w(noms_id establishment_code nationality_code) }
  let(:excepted_attrs) { %w(id created_at updated_at date_of_birth) }

  context 'when authenticated' do
    before { request.headers['HTTP_AUTHORIZATION'] = "Bearer #{token.token}" }

    describe 'GET #index' do
      it 'returns collection of identity records' do
        create_list(:identity, 2)

        get :index

        expect(JSON.parse(response.body).map { |h| h['id'] })
          .to match_array(Identity.all.pluck(:id))
      end

      it 'paginates records' do
        create_list(:identity, 3)

        get :index, page: '1', per_page: '2'

        expect(JSON.parse(response.body).size).to eq 2
      end

      it 'sets total count in response headers' do
        create_list(:identity, 3)

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
                          gender: 'M', date_of_birth: '19650807', pnc_number: '74/832963V', cro_number: '195942/38G')
      end

      let!(:identity_2) do
        create(:identity, offender: offender_1,
                          given_name: 'DEBBY', middle_names: 'LAURA MARTA', surname: 'YELLOW',
                          gender: 'M', date_of_birth: '19691128', pnc_number: '99/135626A', cro_number: '639816/39Y')
      end

      let!(:identity_3) do
        create(:identity, offender: offender_2,
                          given_name: 'JONAS', middle_names: 'JULIUS', surname: 'CEASAR',
                          gender: 'F', date_of_birth: '19541009', pnc_number: '38/836893N', cro_number: '741860/84F')
      end

      context 'searching for NOMS ID' do
        context 'when query matches' do
          let(:search_params) { { noms_id: 'A9876ZX' } }

          before { get :search, search_params }

          it 'returns collection of identity records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] })
              .to match_array([identity_3['id']])
          end
        end

        context 'when query does not match' do
          let(:search_params) { { noms_id: 'A9876XY' } }

          before { get :search, search_params }

          it 'returns an empty set' do
            expect(response.body).to eq('[]')
          end
        end
      end

      context 'name search' do
        context 'when query matches' do
          let(:search_params) { { given_name: 'deb', surname: 'yellow' } }

          before { get :search, search_params }

          it 'returns collection of identity records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] })
              .to match_array([identity_2['id']])
          end
        end

        context 'when query does not match' do
          let(:search_params) { { given_name: 'luke' } }

          before { get :search, search_params }

          it 'returns an empty set' do
            expect(response.body).to eq('[]')
          end
        end
      end

      it 'paginates records' do
        get :search, page: '1', per_page: '2'

        expect(JSON.parse(response.body).size).to eq 2
      end

      it 'sets total count in response headers' do
        get :search

        expect(response.headers['Total-Count']).to eq '3'
      end
    end

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
            expect(identity_attrs).to include(params.except(*excepted_attrs, *offender_attrs))
            expect(identity.date_of_birth).to eq Date.parse(params['date_of_birth'])
          end

          it 'sets current_offender on the created offender' do
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
            expect(identity_attrs).to include(params.except(*excepted_attrs, *offender_attrs))
            expect(identity.date_of_birth).to eq Date.parse(params['date_of_birth'])
          end

          it 'does not create a new offender' do
            expect(Offender.count).to be 1
          end

          it 'does not update current_offender field on offender' do
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

      context 'when invalid' do
        context 'with validation errors on the identity' do
          before do
            params.delete('gender')
            post :create, identity: params
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
              'error' => { 'gender' => ['can\'t be blank'] }
            )
          end
        end

        context 'with validation errors on the offender' do
          before do
            params.delete('noms_id')
            post :create, identity: params
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
              'error' => { 'noms_id' => ['can\'t be blank'] }
            )
          end
        end
      end
    end

    describe 'PATCH #update' do
      let!(:identity) { create(:identity, surname: 'BLACK', offender: create(:offender, noms_id: 'A7104HJ')) }

      context 'when valid' do
        before do
          patch :update, id: identity, identity: params
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

        it 'returns success:true' do
          expect(response.body).to eq('{"success":true}')
        end
      end

      context 'when invalid' do
        context 'with validation errors on the identity' do
          before do
            patch :update, id: identity, identity: params.merge(surname: '')
          end

          it 'does not update the identity record' do
            expect(identity.surname).to eq('BLACK')
          end

          it 'returns status "unprocessable entity"' do
            expect(response.status).to be 422
          end

          it 'returns JSON error' do
            expect(JSON.parse(response.body)).to eq(
              'error' => { 'surname' => ['can\'t be blank'] }
            )
          end
        end
      end

      context 'with validation errors on the offender' do
        before do
          patch :update, id: identity, identity: params.merge(noms_id: '')
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
            'error' => { 'noms_id' => ['can\'t be blank'] }
          )
        end
      end
    end

    describe 'PATCH #current' do
      let!(:offender) { create(:offender) }
      let!(:identity_one) { create(:identity, surname: 'BLACK', offender: offender) }
      let!(:identity_two) { create(:identity, surname: 'BLACK', offender: offender) }

      context 'success' do
        before do
          offender.update_attribute(:current_identity, identity_one)
          patch :current, id: identity_two
          offender.reload
        end

        it 'updates the offender current identity' do
          expect(offender.current_identity).to eq identity_two
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
          offender.update_attribute(:current_identity, identity_one)

          offender_double = instance_double(Offender)
          identity_double = instance_double(Identity)
          allow(Identity).to receive(:find).and_return(identity_double)
          allow(identity_double).to receive(:offender).and_return(offender_double)
          allow(offender_double).to receive(:update_attribute).and_return(false)

          patch :current, id: identity_two

          offender.reload
        end

        it 'updates the offender current identity' do
          expect(offender.current_identity).to eq identity_one
        end

        it 'returns status 422' do
          expect(response.status).to be 422
        end

        it 'returns success:false' do
          expect(response.body).to eq('{"success":false}')
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

    describe 'POST #create' do
      before { post :create, identity: params }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'PATCH #update' do
      let(:identity) { create(:identity) }

      before do
        patch :update, id: identity.id, identity: params
      end

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end
  end
end
