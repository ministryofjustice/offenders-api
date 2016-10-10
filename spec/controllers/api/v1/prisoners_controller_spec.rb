require 'rails_helper'

RSpec.describe Api::V1::PrisonersController, type: :controller do
  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }
  let(:params) do
    {
      "noms_id" => 'A1234BC',
      "given_name" => 'JOHN',
      "middle_names" => 'FRANK MARK',
      "surname" => 'SMITH',
      "title" => 'MR',
      "suffix" => 'DR',
      "date_of_birth" => '19711010',
      "gender" => 'M',
      "nationality_code" => 'BRIT',
      "pnc_number" => 'PNC123',
      "cro_number" => 'CRO987',
      "establishment_code" => 'LEI',
      "aliases" => [
        {
          "given_name" => 'ROBERT',
          "middle_names" => 'JAMES DAN',
          "surname" => 'BLACK',
          "title" => 'MR',
          "suffix" => 'DR',
          "date_of_birth" => '19801010',
          "gender" => 'M'
        },
        {
          "given_name" => 'STEVEN',
          "middle_names" => 'TOM PAUL',
          "surname" => 'LITTLE',
          "title" => 'MR',
          "suffix" => 'DR',
          "date_of_birth" => '19780503',
          "gender" => 'M'
        }
      ]
    }
  end
  let(:excepted_attrs) { %w[id created_at updated_at date_of_birth aliases] }

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

        get :index, page: '1', per_page: '2'

        expect(JSON.parse(response.body).size).to eq 2

        get :index, page: '2', per_page: '2'

        expect(JSON.parse(response.body).size).to eq 1
      end

      it 'filters records updated after a timestamp' do
        create(:prisoner, updated_at: 1.year.ago)
        create(:prisoner, updated_at: 5.days.ago)

        get :index, updated_after: 10.days.ago

        expect(JSON.parse(response.body).size).to eq 1
      end
    end

    describe 'GET #search' do
      let!(:prisoner_1) do
        create(:prisoner, noms_id: 'AA123', date_of_birth: Date.parse('19750201'),
                          given_name: 'DARREN', middle_names: 'MARK JOHN', surname: 'WHITE')
      end

      let!(:prisoner_2) do
        create(:prisoner, noms_id: 'AB123', date_of_birth: Date.parse('19750201'),
                          given_name: 'JUSTIN', middle_names: 'JAKE PAUL', surname: 'BLACK')
      end

      let!(:alias_1) do
        create(:alias, prisoner: prisoner_1, given_name: 'TONY', middle_names: 'FRANK ROBERT', surname: 'BROWN')
      end

      context 'searching for date of birth - NOMS ID pairs' do
        context 'when query matches' do
          let(:search_params) { { dob_noms: [{ noms_id: 'AA123', date_of_birth: Date.parse('19750201') }] } }

          before { get :search, search_params }

          it 'returns collection of prisoner records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] }).
              to match_array([prisoner_1['id']])
          end
        end

        context 'when query does not match' do
          let(:search_params) { { dob_noms: [{ noms_id: 'AA123', date_of_birth: Date.parse('19650201') }] } }

          before { get :search, search_params }

          it 'returns an empty set' do
            expect(response.body).to eq('[]')
          end
        end
      end

      context 'searching for NOMS ID' do
        context 'when query matches' do
          let(:search_params) { { noms_id: 'AA123' } }

          before { get :search, search_params }

          it 'returns collection of prisoner records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] }).
              to match_array([prisoner_1['id']])
          end
        end

        context 'when query does not match' do
          let(:search_params) { { noms_id: 'XX123' } }

          before { get :search, search_params }

          it 'returns an empty set' do
            expect(response.body).to eq('[]')
          end
        end
      end

      context 'searching for given_name' do
        context 'when query matches' do
          let(:search_params) { { given_name: 'darr', surname: 'whi' } }

          before { get :search, search_params }

          it 'returns collection of prisoner records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] }).
              to match_array([prisoner_1['id']])
          end
        end

        context 'when query matches an alias' do
          let(:search_params) { { given_name: 'ton', surname: 'bro' } }

          before { get :search, search_params }

          it 'returns collection of prisoner records matching query' do
            expect(JSON.parse(response.body).map { |p| p['id'] }).
              to match_array([prisoner_1['id']])
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

    describe 'POST #create' do
      context 'when valid' do
        before { post :create, prisoner: params }

        it 'creates a new prisoner record with given params' do
          prisoner = Prisoner.first
          prisoner_attrs = prisoner.attributes.except(*excepted_attrs)
          expect(prisoner_attrs).to include(params.except(*excepted_attrs))
          expect(prisoner.date_of_birth).to eq Date.parse(params["date_of_birth"])
        end

        it 'updates aliases' do
          first_alias_attrs = Prisoner.first.aliases.first.attributes.except(*excepted_attrs)
          last_alias_attrs = Prisoner.first.aliases.last.attributes.except(*excepted_attrs)
          expect(first_alias_attrs).to include params["aliases"].first.except(*excepted_attrs)
          expect(last_alias_attrs).to include params["aliases"].last.except(*excepted_attrs)
        end

        it 'returns status 201/created' do
          expect(response.status).to be 201
        end

        it 'returns the id of the created record' do
          expect(response.body).to eq({ id: Prisoner.first.id }.to_json)
        end
      end

      context 'when invalid' do
        before do
          params.delete("gender")
          post :create, prisoner: params
        end

        it 'does not create a prisoner record' do
          expect(Prisoner.count).to be 0
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
    end

    describe 'PATCH #update' do
      let!(:prisoner) { create(:prisoner, noms_id: 'A1234XX') }

      context 'when valid' do
        before do
          patch :update, id: prisoner, prisoner: params
          prisoner.reload
        end

        it 'updates the prisoner record' do
          prisoner_attrs = prisoner.attributes.except(*excepted_attrs)
          expect(prisoner_attrs).to include(params.except(*excepted_attrs))
          expect(prisoner.date_of_birth).to eq Date.parse(params["date_of_birth"])
        end

        it 'updates aliases' do
          first_alias_attrs = prisoner.aliases.first.attributes.except(*excepted_attrs)
          last_alias_attrs = prisoner.aliases.last.attributes.except(*excepted_attrs)
          expect(first_alias_attrs).to include params["aliases"].first.except(*excepted_attrs)
          expect(last_alias_attrs).to include params["aliases"].last.except(*excepted_attrs)
          expect(prisoner.aliases.first.date_of_birth).to eq Date.parse(params["aliases"].first["date_of_birth"])
          expect(prisoner.aliases.last.date_of_birth).to eq Date.parse(params["aliases"].last["date_of_birth"])
        end

        it 'returns status "success"' do
          expect(response.status).to be 200
        end

        it 'returns success:true' do
          expect(response.body).to eq("{\"success\":true}")
        end
      end

      context 'when invalid' do
        before do
          patch :update, id: prisoner, prisoner: { noms_id: 'B1234BC', gender: '' }
          prisoner.reload
        end

        it 'does not update the prisoner record' do
          expect(prisoner.noms_id).to eq('A1234XX')
        end

        it 'returns status "unprocessable entity"' do
          expect(response.status).to be 422
        end

        it 'returns JSON error' do
          expect(JSON.parse(response.body)).to eq(
            'error' => { 'gender' => ['can\'t be blank'] }
          )
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
      before { post :create, prisoner: params }

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end

    describe 'PATCH #update' do
      let(:prisoner) { create(:prisoner) }

      before do
        patch :update, id: prisoner.id, prisoner: params
      end

      it 'returns status 401' do
        expect(response.status).to be 401
      end
    end
  end
end
