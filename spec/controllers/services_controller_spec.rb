require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
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
    let(:application) { create(:application) }

    before { get :show, id: application }

    it 'should return status 200' do
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

  describe 'GET #edit' do
    let(:application) { create(:application) }

    before { get :edit, id: application }

    it 'should return status 200' do
      expect(response.status).to eq(200)
    end

    it 'should render the index template' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
  end

  describe 'PATCH/PUT #update' do
  end

  describe 'DELETE #destroy' do
  end
end
