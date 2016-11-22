require 'rails_helper'

RSpec.describe Api::V1::OffendersController, type: :controller do
  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }
  # let(:params) do
  #   {
  #     'noms_id' => 'A1234BC',
  #     'given_name' => 'JOHN',
  #     'middle_names' => 'FRANK MARK',
  #     'surname' => 'SMITH',
  #     'title' => 'MR',
  #     'suffix' => 'DR',
  #     'date_of_birth' => '19711010',
  #     'gender' => 'M',
  #     'nationality_code' => 'BRIT',
  #     'pnc_number' => 'PNC123',
  #     'cro_number' => 'CRO987',
  #     'establishment_code' => 'LEI',
  #     'identities' => [
  #       {
  #         'given_name' => 'ROBERT',
  #         'middle_names' => 'JAMES DAN',
  #         'surname' => 'BLACK',
  #         'title' => 'MR',
  #         'suffix' => 'DR',
  #         'date_of_birth' => '19801010',
  #         'gender' => 'M'
  #       },
  #       {
  #         'given_name' => 'STEVEN',
  #         'middle_names' => 'TOM PAUL',
  #         'surname' => 'LITTLE',
  #         'title' => 'MR',
  #         'suffix' => 'DR',
  #         'date_of_birth' => '19780503',
  #         'gender' => 'M'
  #       }
  #     ]
  #   }
  # end
  let(:excepted_attrs) { %w(id created_at updated_at date_of_birth identities) }

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
        create(:offender, noms_id: 'AB123')
      end

      let!(:identity_1) do
        create(:identity, offender: offender_1, given_name: 'DARREN', middle_names: 'FRANK ROBERT', surname: 'WHITE')
      end

      let!(:identity_2) do
        create(:identity, offender: offender_2, given_name: 'TONY', middle_names: 'FRANK ROBERT', surname: 'BROWN')
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
          let(:search_params) { { noms_id: 'A9876XY' } }

          before { get :search, search_params }

          it 'returns an empty set' do
            expect(response.body).to eq('[]')
          end
        end
      end

      context 'name search' do
        context 'when query matches' do
          let(:search_params) { { given_name: 'darr', surname: 'whi' } }

          before { get :search, search_params }

          it 'returns collection of offender records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] })
              .to match_array([offender_1['id']])
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

    # describe 'POST #create' do
    #   context 'when valid' do
    #     before { post :create, offender: params }
    #
    #     it 'creates a new offender record with given params' do
    #       offender = Offender.first
    #       offender_attrs = offender.attributes.except(*excepted_attrs)
    #       expect(offender_attrs).to include(params.except(*excepted_attrs))
    #       expect(offender.date_of_birth).to eq Date.parse(params['date_of_birth'])
    #     end
    #
    #     it 'updates identities' do
    #       first_identity_attrs = Offender.first.identities.first.attributes.except(*excepted_attrs)
    #       last_identity_attrs = Offender.first.identities.last.attributes.except(*excepted_attrs)
    #       expect(first_identity_attrs).to include params['identities'].first.except(*excepted_attrs)
    #       expect(last_identity_attrs).to include params['identities'].last.except(*excepted_attrs)
    #     end
    #
    #     it 'returns status 201/created' do
    #       expect(response.status).to be 201
    #     end
    #
    #     it 'returns the id of the created record' do
    #       expect(response.body).to eq({ id: Offender.first.id }.to_json)
    #     end
    #   end
    #
    #   context 'when invalid' do
    #     before do
    #       params.delete('gender')
    #       post :create, offender: params
    #     end
    #
    #     it 'does not create a offender record' do
    #       expect(Offender.count).to be 0
    #     end
    #
    #     it 'returns status 422/unprocessable entity' do
    #       expect(response.status).to be 422
    #     end
    #
    #     it 'returns error for missing attribute' do
    #       expect(JSON.parse(response.body)).to eq(
    #         'error' => { 'gender' => ['can\'t be blank'] }
    #       )
    #     end
    #   end
    # end
    #
    # describe 'PATCH #update' do
    #   let!(:offender) { create(:offender, noms_id: 'A1234XX') }
    #
    #   context 'when valid' do
    #     before do
    #       patch :update, id: offender, offender: params
    #       offender.reload
    #     end
    #
    #     it 'updates the offender record' do
    #       offender_attrs = offender.attributes.except(*excepted_attrs)
    #       expect(offender_attrs).to include(params.except(*excepted_attrs))
    #       expect(offender.date_of_birth).to eq Date.parse(params['date_of_birth'])
    #     end
    #
    #     it 'updates identities' do
    #       first_identity_attrs = offender.identities.first.attributes.except(*excepted_attrs)
    #       last_identity_attrs = offender.identities.last.attributes.except(*excepted_attrs)
    #       expect(first_identity_attrs).to include params['identities'].first.except(*excepted_attrs)
    #       expect(last_identity_attrs).to include params['identities'].last.except(*excepted_attrs)
    #       expect(offender.identities.first.date_of_birth).to eq Date.parse(params['identities']first['date_of_birth'])
    #       expect(offender.identities.last.date_of_birth).to eq Date.parse(params['identities'].last['date_of_birth'])
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
    #       patch :update, id: offender, offender: { noms_id: 'B1234BC', gender: '' }
    #       offender.reload
    #     end
    #
    #     it 'does not update the offender record' do
    #       expect(offender.noms_id).to eq('A1234XX')
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
    #   before { post :create, offender: params }
    #
    #   it 'returns status 401' do
    #     expect(response.status).to be 401
    #   end
    # end
    #
    # describe 'PATCH #update' do
    #   let(:offender) { create(:offender) }
    #
    #   before do
    #     patch :update, id: offender.id, offender: params
    #   end
    #
    #   it 'returns status 401' do
    #     expect(response.status).to be 401
    #   end
    # end
  end
end
