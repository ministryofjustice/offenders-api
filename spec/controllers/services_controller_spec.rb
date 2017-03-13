require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
  let(:params) { { 'name' => 'NOMIS', 'redirect_uri' => 'https://nomis.com', scopes: 'write' } }

  context 'when admin' do
    let(:user) { create(:user, :admin) }

    before { sign_in user }

    describe 'GET #index' do
      before { get :index }

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    describe 'GET #show' do
      let(:application) { create(:application) }

      before { get :show, params: { id: application } }

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    describe 'GET #new' do
      before { get :new }

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    describe 'GET #edit' do
      let(:application) { create(:application) }

      before { get :edit, params: { id: application } }

      it 'returns status 200' do
        expect(response.status).to be 200
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    describe 'POST #create' do
      context 'when valid' do
        before { post :create, params: { service: params } }

        it 'creates a new Doorkeeper::Application' do
          expect(Doorkeeper::Application.count).to be 1
          expect(Doorkeeper::Application.first.name).to eq 'NOMIS'
          expect(Doorkeeper::Application.first.redirect_uri).to eq 'https://nomis.com'
          expect(Doorkeeper::Application.first.scopes.to_s).to eq 'write'
        end

        it 'redirects to index' do
          expect(response).to redirect_to(services_url)
        end
      end

      context 'when invalid' do
        before do
          params.delete('name')
          post :create, params: { service: params }
        end

        it 'does not create a Doorkeeper::Application' do
          expect(Doorkeeper::Application.count).to be 0
        end

        it 'renders the new template' do
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'PATCH/PUT #update' do
      let(:application) { create(:application, name: 'service_name') }

      context 'when valid' do
        before do
          patch :update, params: { id: application, service: params }
        end

        it 'updates a new Doorkeeper::Application' do
          expect(Doorkeeper::Application.first.name).to eq 'NOMIS'
        end

        it 'redirects to index' do
          expect(response).to redirect_to(services_url)
        end
      end

      context 'when invalid' do
        before do
          params['name'] = ''
          patch :update, params: { id: application, service: params }
        end

        it 'does not update a Doorkeeper::Application' do
          expect(Doorkeeper::Application.first.name).to eq 'service_name'
        end

        it 'renders the edit template' do
          expect(response).to render_template(:edit)
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:application) { create(:application) }

      before do
        delete :destroy, params: { id: application }
      end

      it 'deletes a Doorkeeper::Application' do
        expect(Doorkeeper::Application.count).to eq 0
      end

      it 'redirects to index' do
        expect(response).to redirect_to(services_url)
      end
    end
  end

  context 'when staff' do
    let(:user) { create(:user, :staff) }

    before { sign_in user }

    describe 'GET #index' do
      before { get :index }

      it 'redirects to root' do
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'GET #show' do
      let(:application) { create(:application) }

      before { get :show, params: { id: application } }

      it 'redirects to root' do
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'GET #new' do
      before { get :new }

      it 'redirects to root' do
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'GET #edit' do
      let(:application) { create(:application) }

      before { get :edit, params: { id: application } }

      it 'redirects to root' do
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'POST #create' do
      before { post :create, params: { service: params } }

      it 'redirects to root' do
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'PATCH/PUT #update' do
      let(:application) { create(:application) }

      before { patch :update, params: { id: application, service: params } }

      it 'redirects to root' do
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'DELETE #destroy' do
      let(:application) { create(:application) }

      before { delete :destroy, params: { id: application } }

      it 'redirects to root' do
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
