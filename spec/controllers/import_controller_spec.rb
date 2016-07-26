require 'rails_helper'

RSpec.describe ImportController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in user }

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
  end
end
