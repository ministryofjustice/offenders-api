require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    before { get :index }

    it 'should return status 200' do
      expect(response.status).to eq(200)
    end

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end
  end
end
