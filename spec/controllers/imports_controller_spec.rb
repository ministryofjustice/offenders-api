require 'rails_helper'

RSpec.describe ImportsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET #index' do
    before { get :index }

    it 'should return status 200' do
      expect(response.status).to eq(200)
    end

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let(:import) { Import.create(file: fixture_file_upload('files/sample_import_1.csv', 'text/csv')) }

    before { get :show, id: import }

    it 'should render status 200' do
      expect(response.status).to eq(200)
    end

    it 'should render the show template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'should return status 200' do
      expect(response.status).to eq(200)
    end

    it 'should render the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:file) { fixture_file_upload('files/sample_import_1.csv', 'text/csv') }
    let(:import_params) do
      {
        import: {
          file: file
        }
      }
    end

    context 'creates an import when valid' do
      it 'should create an import' do
        expect {
          post :create, import_params
        }.to change(Import, :count).by(1)
      end

      it 'should redirect to the imports index url' do
        post :create, import_params
        expect(response).to redirect_to(import_url(Import.first))
      end
    end

    context 'does not create an import when not valid' do
      before { import_params[:import][:file] = '' }

      it 'should not create an import' do
        expect {
          post :create, import_params
        }.to_not change(Import, :count)
      end

      it 'should render the new action' do
        post :create, import_params
        expect(response).to render_template(:new)
      end
    end
  end
end
