require 'rails_helper'

RSpec.describe ImportsController, type: :controller do
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
    let(:file) { fixture_file_upload('files/prisoners.csv', 'text/csv') }
    let(:import_params) do
      {
        import: {
          file: file
        }
      }
    end

    context 'when valid' do
      before { allow(ImportProcessor).to receive(:perform_async) }

      it 'creates an import' do
        expect {
          post :create, import_params
        }.to change(Import, :count).by(1)
      end

      it 'redirects to the imports index url' do
        post :create, import_params
        expect(response).to redirect_to(imports_path)
      end
    end

    context 'when not valid' do
      before { import_params[:import][:file] = '' }

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
