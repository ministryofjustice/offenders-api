require 'rails_helper'

RSpec.describe ImportsController, type: :controller do
  let(:user) { create(:user, :admin) }

  before { sign_in user }

  describe 'GET #new' do
    before { get :new }

    it 'returns status 200' do
      expect(response.status).to be 200
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:prisoners_file) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
    let(:aliases_file) { fixture_file_upload('files/aliases.csv', 'text/csv') }
    let(:import_params) do
      {
        import: {
          prisoners_file: prisoners_file,
          aliases_file: aliases_file
        }
      }
    end

    context 'when valid' do
      it 'creates an import' do
        expect {
          post :create, import_params
        }.to change(Import, :count).by(1)
      end

      it 'redirects to new import url' do
        post :create, import_params
        expect(response).to redirect_to(new_import_path)
      end
    end

    context 'when not valid' do
      before { import_params[:import][:prisoners_file] = '' }

      it 'does not create an import' do
        expect {
          post :create, import_params
        }.to_not change(Import, :count)
      end

      it 'renders the new action' do
        post :create, import_params
        expect(response).to render_template(:new)
      end
    end
  end
end
